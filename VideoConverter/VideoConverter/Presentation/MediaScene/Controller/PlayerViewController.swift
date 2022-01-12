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
    private var assetPlayer: AssetPlayer!
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        AppDelegate.AppUtility.lockOrientation([.portrait,.landscapeLeft])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
        assetPlayer.pause()
    }

    static func create(with assetManager: AssetManager, tappedInex: Int) -> PlayerViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as? PlayerViewController else {
            return PlayerViewController()
        }
 
        return vc
    }
    
    private func setHeaderView() {
        self.headerView = HeaderView()
        self.headerView.delegate = self
        self.headerView.alpha = 0.2
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        
        if let title = assetPlayer.player.currentItem?.asset as? AVURLAsset {
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
        self.playerView.player = self.assetPlayer.player
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(didTappedPlayerView(_:)))
        self.playerView.addGestureRecognizer(tapGesture)
        self.playerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playerView)

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
    
    func setPlayer(assetManager: AssetManager, tappedIndex: Int) {
        self.assetManager = assetManager
        self.playingIndex = tappedIndex
        let asset = assetManager.assets[tappedIndex] as! AVURLAsset
        
        self.assetPlayer = AssetPlayer.shared
        self.assetPlayer.initPlayer(url: asset.url, nowPlayableBehavior: self)
        
        self.assetPlayer.nextTrack(closure: { [weak self] in
            self?.playNextTrack()
        })
        self.assetPlayer.previousTrack { [weak self] in
            self?.playPreviousTrack()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(configPlayButtonImage), name: Notification.Name("playerStateDidChanged"), object: self.assetPlayer)
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
    
    @objc func configPlayButtonImage() {
        DispatchQueue.main.async {
            if self.assetPlayer.playerState == .playing {
                self.playerControlView.configurePlayButton(image: UIImage(systemName: "pause.fill")!)
            } else {
                self.playerControlView.configurePlayButton(image: UIImage(systemName: "play.fill")!)
            }
        }
    }

    private func addObserverForPlayEndTime(isRepeatPlay: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: self.assetPlayer.player.currentItem)
        
        if isRepeatPlay {
            NotificationCenter.default.addObserver(self, selector: #selector(rePlay), name: .AVPlayerItemDidPlayToEndTime, object: self.assetPlayer.player.currentItem)
            
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(playNextTrack), name: .AVPlayerItemDidPlayToEndTime, object: self.assetPlayer.player.currentItem)
        }
    }
    
    @objc func rePlay() {
   
        let nextItem = AVPlayerItem(asset: (self.assetManager.assets[playingIndex]))
        self.assetPlayer.player.replaceCurrentItem(with: nextItem)
        self.assetPlayer.play()
     
        self.addObserverForPlayEndTime(isRepeatPlay: self.isSelectedRepeatPlayButton)
    }
    
    @objc func playNextTrack() {
        
        let assets = self.assetManager.assets
        
        for _ in 0..<assets.count {
            self.playingIndex = playingIndex < (assets.count - 1) ? (playingIndex + 1) : 0
            if assets[playingIndex].isPlayable { break }
        }

        let nextItem = AVPlayerItem(asset: (assets[playingIndex]))
        self.assetPlayer.player.replaceCurrentItem(with: nextItem)
        self.assetPlayer.play()

        self.addObserverForPlayEndTime(isRepeatPlay: self.isSelectedRepeatPlayButton)
    }
    
    @objc func playPreviousTrack() {
        
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: self.assetPlayer.player.currentItem)
        
        let assets = self.assetManager.assets

        for _ in 0..<assets.count {
            playingIndex = playingIndex >= 1 ? (playingIndex - 1) : (assets.count - 1)
            
            if assets[playingIndex].isPlayable { break }
        }
        
        let nextItem = AVPlayerItem(asset: assets[playingIndex])
        self.assetPlayer.player.replaceCurrentItem(with: nextItem)
        self.assetPlayer.play()

        self.addObserverForPlayEndTime(isRepeatPlay: self.isSelectedRepeatPlayButton)
    }

    @objc func didTappedPlayerView(_ sender: UITapGestureRecognizer) {
        
        self.playerControlView.isHidden = !playerControlView.isHidden
        self.headerView.isHidden = !headerView.isHidden
    }
    
    private func addTimeObserver() {
        
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        
        _ = assetPlayer.player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: {
            [weak self] time in
            
            guard let currentItem = self?.assetPlayer.player.currentItem else { return }
            guard currentItem.status.rawValue == AVPlayerItem.Status.readyToPlay.rawValue else {return}
            self?.playerControlView.configureSlider(maxValue: Float(currentItem.duration.seconds),
                                                    minValue: 0,
                                                    value: Float(currentItem.currentTime().seconds))
            
            self?.playerControlView.configureTimeLabel(currentTime: currentItem.currentTime().seconds.durationText,
                                                       endTime: currentItem.duration.durationText)
            
            let asset = currentItem.asset as! AVURLAsset
            
            self?.headerView.configure(title: asset.url.lastPathComponent, exitButtonIsHidden: false, sceneRotateButtonIsHidden: false)
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "duration",
        let duration = assetPlayer.player.currentItem?.duration.seconds,
        duration > 0.0 {
            
            self.playerControlView.configureTimeLabel(endTime: duration.durationText)
        }
    }
}

extension PlayerViewController: PlayerControlViewDelegate {

    func didTappedPlayButton(_ button: UIButton) {
        if assetPlayer.playerState == .playing {
            self.assetPlayer.pause()
        } else {
            self.assetPlayer.play()
        }
    }

    func didTappedBackwardButton() {
        assetPlayer.backward(to: 10.0)
    }
    
    func didTappedForwardButton() {
        assetPlayer.forward(to: 10.0)
    }

    func sliderValueChanged(_ slider: UISlider) {
        let time = CMTimeMake(value: Int64(slider.value * 1000) , timescale: 1000)
        assetPlayer.player.seek(to: time)
    }
    
    func didTappedRepeatPlayButton(_ button: UIButton) {

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
        
        if UIDevice.current.orientation == .portrait {
            AppDelegate.AppUtility.lockOrientation([.portrait, .landscapeLeft], andRotateTo: .landscapeLeft)
        } else {
            AppDelegate.AppUtility.lockOrientation([.portrait, .landscapeLeft], andRotateTo: .portrait)
        }
    }
    
    func didTappedExitButton() {
        AppDelegate.AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        self.dismiss(animated: true, completion: nil)
    }
}

extension PlayerViewController: NowPlayable {
  
    var defaultAllowsExternalPlayback: Bool {
        return true
    }
    
    var defaultCommands: [NowPlayableCommand] {
        return [.play, .pause, .nextTrack, .previousTrack, .changePlaybackPosition]
    }
}
