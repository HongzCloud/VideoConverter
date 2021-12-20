//
//  PlayerViewController.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/21.
//

import UIKit
import AVFoundation
import MediaPlayer

class PlayerViewController: UIViewController {

    private var playerView: PlayerView!
    private var playerControlView: PlayerControlView!
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    private var headerView: HeaderView!
    private var assetManager: AssetManager!
    private var playingIndex: Int!
    private var orientation: UIInterfaceOrientation!
    private var isSelectedRepeatPlayButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPlayerView()
        setHeaderView()
        setPlayerControlView()
        addTimeObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
        player.pause()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.playerLayer.frame = playerView.bounds
    }
    
    static func create(with assetManager: AssetManager, tappedInex: Int) -> PlayerViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as? PlayerViewController else {
            return PlayerViewController()
        }
        vc.setPlayer(assetManager: assetManager, tappedIndex: tappedInex)
        
        return vc
    }
    
    func setPlayer(assetManager: AssetManager, tappedIndex: Int) {
        self.assetManager = assetManager
        self.playingIndex = tappedIndex
        let asset = assetManager.assets[tappedIndex] as! AVURLAsset
        self.player = AVPlayer(url: asset.url)
        self.playerLayer = AVPlayerLayer(player: player)
        self.playerLayer.videoGravity = .resizeAspect
        self.player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new,.initial], context: nil)
        
        // Background 재생을 위한 Audio Session 설정
         let audioSession = AVAudioSession.sharedInstance()
         do {
             try audioSession.setCategory(.playback, mode: .default, options: [])
         } catch let error as NSError {
             Log.error("audioSession 설정 오류", error.localizedDescription)
         }
        
        self.remoteCommandCenterSetting()
        self.remoteCommandInfoCenterSetting()
        self.addObserverForBackground()
        self.addObserverForForground()
        self.addObserverForPlayEndTime(isRepeatPlay: self.isSelectedRepeatPlayButton)
    }
    
    private func remoteCommandCenterSetting() {
        // remote control event 받기 시작
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        let center = MPRemoteCommandCenter.shared()
        center.nextTrackCommand.removeTarget(nil)
        center.previousTrackCommand.removeTarget(nil)
        center.playCommand.removeTarget(nil)
        center.pauseCommand.removeTarget(nil)
        center.changePlaybackPositionCommand.removeTarget(nil)
        
        // 제어 센터 재생 버튼
        center.playCommand.addTarget { [weak self] (commandEvent) -> MPRemoteCommandHandlerStatus in
            
            self?.player.play()
            self?.nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: CMTimeGetSeconds(self?.player.currentItem?.currentTime() ?? CMTime.zero))
            self?.nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1
            MPNowPlayingInfoCenter.default().nowPlayingInfo = self?.nowPlayingInfo
            return .success
        }
        
        // 제어 센터 일시정지 버튼
        center.pauseCommand.addTarget { [weak self] (commandEvent) -> MPRemoteCommandHandlerStatus in
            self?.player.pause()
            self?.nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: CMTimeGetSeconds(self?.player.currentItem!.currentTime() ?? CMTime.zero))
            self?.nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0
            MPNowPlayingInfoCenter.default().nowPlayingInfo = self?.nowPlayingInfo
            return .success
        }

        // 제어 센터 다음트랙 버튼
        center.nextTrackCommand.addTarget { [weak self] (commandEvent) -> MPRemoteCommandHandlerStatus in
            self?.playNextTrack()
            self?.remoteCommandInfoCenterSetting()
            return .success
        }
        
        // 제어 센터 이전트랙 버튼
        center.previousTrackCommand.addTarget { [weak self] (commandEvent) -> MPRemoteCommandHandlerStatus in
            self?.playPreviousTrack()
            self?.remoteCommandInfoCenterSetting()
            return .success
        }
        
        //slider 재생 위치 변경
        center.changePlaybackPositionCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
            if let positionTime = (commandEvent as? MPChangePlaybackPositionCommandEvent)?.positionTime {
                let seekTime = CMTime(value: Int64(positionTime), timescale: 1)
                self.player.seek(to: seekTime)
            }
            return .success
        }

        center.playCommand.isEnabled = true
        center.pauseCommand.isEnabled = true
        center.nextTrackCommand.isEnabled = true
        center.previousTrackCommand.isEnabled = true
        center.changePlaybackPositionCommand.isEnabled = true
    }
    
    private func addObserverForPlayEndTime(isRepeatPlay: Bool) {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
        
        if isRepeatPlay {
            NotificationCenter.default.addObserver(self, selector: #selector(rePlay), name: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
            
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(playNextTrack), name: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
        }
    }
    
    @objc func rePlay() {
    
        let center = MPNowPlayingInfoCenter.default()
    
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.player.currentItem?.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: CMTimeGetSeconds(self.player.currentItem?.currentTime() ?? CMTime.zero))
        
        center.nowPlayingInfo = nowPlayingInfo
        
        let nextItem = AVPlayerItem(asset: (self.assetManager.assets[playingIndex]))
        self.player.replaceCurrentItem(with: nextItem)
        self.player.play()
        self.remoteCommandInfoCenterSetting()
       
        self.addObserverForPlayEndTime(isRepeatPlay: self.isSelectedRepeatPlayButton)
    }
    
    @objc func playNextTrack() {
        
        let assets = self.assetManager.assets
        
        for _ in 0..<assets.count {
            self.playingIndex = playingIndex < (assets.count - 1) ? (playingIndex + 1) : 0
            if assets[playingIndex].isPlayable { break }
        }

        let nextItem = AVPlayerItem(asset: (assets[playingIndex]))
        self.player.replaceCurrentItem(with: nextItem)
        self.player.play()
        self.playerControlView.configurePlayButton(image: UIImage(systemName: "pause.fill")!)
        self.remoteCommandInfoCenterSetting()
        self.addObserverForPlayEndTime(isRepeatPlay: self.isSelectedRepeatPlayButton)
    }
    
    @objc func playPreviousTrack() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
        
        let assets = self.assetManager.assets

        for _ in 0..<assets.count {
            playingIndex = playingIndex >= 1 ? (playingIndex - 1) : (assets.count - 1)
            
            if assets[playingIndex].isPlayable { break }
        }
        
        let nextItem = AVPlayerItem(asset: assets[playingIndex])
        player.replaceCurrentItem(with: nextItem)
        remoteCommandInfoCenterSetting()
        self.playerControlView.configurePlayButton(image: UIImage(systemName: "play.fill")!)

        self.addObserverForPlayEndTime(isRepeatPlay: self.isSelectedRepeatPlayButton)
    }
    
    
    var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [String: Any]()
    
    private func remoteCommandInfoCenterSetting() {

        let center = MPNowPlayingInfoCenter.default()
       
        let asset = self.player.currentItem?.asset as! AVURLAsset

        nowPlayingInfo[MPMediaItemPropertyTitle] = asset.url.lastPathComponent

        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.player.currentItem?.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: CMTimeGetSeconds(self.player.currentItem?.currentTime() ?? CMTime.zero))
        
        center.nowPlayingInfo = nowPlayingInfo
    }
    
    private func addObserverForBackground() {
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(updateRemoteCommandCenter), name: UIScene.willDeactivateNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(updateRemoteCommandCenter), name: UIApplication.willResignActiveNotification, object: nil)
        }
    }
    
    private func addObserverForForground() {
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(updateRemoteCommandCenter), name: UIScene.willEnterForegroundNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(updateRemoteCommandCenter), name: UIApplication.willEnterForegroundNotification, object: nil)
        }
    }
        
    @objc func updateRemoteCommandCenter() {
        
        let isVideo = !self.assetManager.assets[playingIndex].tracks(withMediaType: .video).isEmpty
        
        if player.timeControlStatus == .playing && !isVideo {
            self.playerControlView.configurePlayButton(image: UIImage(systemName: "pause.fill")!)
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.player.rate
        } else {
            self.playerControlView.configurePlayButton(image: UIImage(systemName: "play.fill")!)
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0
        }
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: CMTimeGetSeconds(player.currentItem!.currentTime()))
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    private func setHeaderView() {
        self.headerView = HeaderView()
        self.headerView.delegate = self
        self.headerView.alpha = 0.2
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        if let title = player.currentItem?.asset as? AVURLAsset {
            self.headerView.configure(title: title.url.lastPathComponent, exitButtonIsHidden: false, sceneRotateButtonIsHidden: false)
        }
        self.playerView.addSubview(headerView)
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 1/14)
        ])
    }
    
    private func setPlayerView() {
        self.playerView = PlayerView()
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(didTappedPlayerView(_:)))
        self.playerView.addGestureRecognizer(tapGesture)
        self.playerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playerView)
        self.playerView.layer.addSublayer(playerLayer)
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.playerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.playerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.playerView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.playerView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.playerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.playerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    @objc func didTappedPlayerView(_ sender: UITapGestureRecognizer) {
        self.playerControlView.isHidden = !playerControlView.isHidden
        self.headerView.isHidden = !headerView.isHidden
    }
    
    private func setPlayerControlView() {
        self.playerControlView = PlayerControlView()
        self.playerControlView.delegate = self
        self.playerControlView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playerControlView)
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.playerControlView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            self.playerControlView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.playerControlView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.playerControlView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.15)
        ])
    }
    
    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        _ = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: {
            [weak self] time in
            guard let currentItem = self?.player.currentItem else { return }
            guard currentItem.status.rawValue == AVPlayerItem.Status.readyToPlay.rawValue else {return}
            self?.playerControlView.configureSlider(maxValue: Float(currentItem.duration.seconds),
                                                    minValue: 0,
                                                    value: Float(currentItem.currentTime().seconds))
            self?.playerControlView.configureTimeLabel(currentTime: currentItem.currentTime().seconds.durationText,
                                                       endTime: currentItem.duration.durationText)
            let asset = self?.player.currentItem?.asset as! AVURLAsset
            self?.headerView.configure(title: asset.url.lastPathComponent, exitButtonIsHidden: false, sceneRotateButtonIsHidden: false)
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player.currentItem?.duration.seconds, duration > 0.0 {
            self.playerControlView.configureTimeLabel(endTime: duration.durationText)
        }
    }
}

extension PlayerViewController: PlayerControlViewDelegate {

    func didTappedPlayButton(_ button: UIButton) {
        if player.timeControlStatus == .playing {
            self.player.pause()
            self.playerControlView.configurePlayButton(image: UIImage(systemName: "play.fill")!)
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 0
        } else {
            self.player.play()
            self.playerControlView.configurePlayButton(image: UIImage(systemName: "pause.fill")!)
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = self.player.rate
        }
    }

    func didTappedBackwardButton() {
        let currentTime = CMTimeGetSeconds(player.currentTime())
        
        if currentTime < 2.0 {
            let assetCount = self.assetManager.assets.count
            playingIndex = playingIndex >= 1 ? (playingIndex - 1) : (assetCount - 1)
            
            let nextItem = AVPlayerItem(asset: assetManager.assets[playingIndex])
            player.replaceCurrentItem(with: nextItem)
            self.addObserverForPlayEndTime(isRepeatPlay: isSelectedRepeatPlayButton)
        }
        
        var newTime = currentTime - 10.0
        
        if newTime < 0 {
            newTime = 0
        }
        
        let time = CMTimeMake(value: Int64(newTime * 1000), timescale: 1000)
        player.seek(to: time)
    }
    
    func didTappedForwardButton() {
        let currentTime = CMTimeGetSeconds(player.currentTime())
        
        if let currentItem = player.currentItem {
            if currentTime > currentItem.duration.seconds - 2.0 {
                self.playNextTrack()
                return
            }
        }
    
        var newTime = currentTime + 10.0
        let duration = self.player.currentItem!.asset.duration
        
        if newTime > CMTimeGetSeconds(duration) {
            newTime = CMTimeGetSeconds(duration)
        }
        
        let time = CMTimeMake(value: Int64(newTime * 1000), timescale: 1000)
        
        player.seek(to: time)
    }

    func sliderValueChanged(_ slider: UISlider) {
        let time = CMTimeMake(value: Int64(slider.value * 1000) , timescale: 1000)
        player.seek(to: time)
    }
    
    func didTappedRepeatPlayButton(_ button: UIButton) {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
        isSelectedRepeatPlayButton = !isSelectedRepeatPlayButton

        self.addObserverForPlayEndTime(isRepeatPlay: isSelectedRepeatPlayButton)
        
        if isSelectedRepeatPlayButton {
            button.tintColor = .greenAndMint
        }
        else {
            button.tintColor = .white
        }
    }
}

extension PlayerViewController: CustomHeaderViewDelegate {
    
    func didTappedSceneRotateButton() {
        if orientation == UIInterfaceOrientation.landscapeRight {
            orientation = UIInterfaceOrientation.portrait
        } else {
            orientation = UIInterfaceOrientation.landscapeRight
        }
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
    func didTappedExitButton() {
        orientation = UIInterfaceOrientation.portrait
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        self.dismiss(animated: true, completion: nil)
    }
}
