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

    private var playerControlView: PlayerControlView!
    private var assetPlayer: AssetPlayer!
    private var headerView: HeaderView!
    private var orientation: UIInterfaceOrientation!
    
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var playListTableView: UITableView!
    @IBOutlet weak var playingTitleLabel: UILabel!
    @IBOutlet weak var playingImageView: UIImageView!
    
    private var viewModel: PlayerViewModel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPlayerView()
        setHeaderView()
        setPlayerControlView()
        setPlayingInfo()
        addTimeObserver()
        addObserverForPlayEndTime(isRepeatPlay: playerControlView.isSelectedRepeatPlayButton)
        playListTableView.dataSource = self
        playListTableView.delegate = self
        playListTableView.register(PlayerListTableViewCell.self, forCellReuseIdentifier: "PlayerListTableViewCell")
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

    // MARK: - Init
    
    static func create(with viewModel: PlayerViewModel) -> PlayerViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as? PlayerViewController else {
            return PlayerViewController()
        }
        vc.viewModel = viewModel
        return vc
    }
    
    private func setHeaderView() {
        self.headerView = HeaderView()
        self.headerView.delegate = self
        self.headerView.alpha = 0.2
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.headerView.configure(title: viewModel.playingTitle, exitButtonIsHidden: false, sceneRotateButtonIsHidden: false)
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
        self.playerView.player = self.assetPlayer.player
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(didTappedPlayerView(_:)))
        self.playerView.addGestureRecognizer(tapGesture)
        self.playerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playerView)
    }
    
    func setPlayer() {
        let avURLAsset = viewModel.playingAsset as! AVURLAsset
        
        self.assetPlayer = AssetPlayer.shared
        self.assetPlayer.initPlayer(url: avURLAsset.url, nowPlayableBehavior: self)
        
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
        
        NSLayoutConstraint.activate([
            self.playerControlView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor, constant: -20),
            self.playerControlView.leadingAnchor.constraint(equalTo: playerView.leadingAnchor),
            self.playerControlView.trailingAnchor.constraint(equalTo: playerView.trailingAnchor),
            self.playerControlView.heightAnchor.constraint(equalTo: playerView.heightAnchor, multiplier: 0.25)
        ])
    }
    
    private func setPlayingInfo() {
        self.playingTitleLabel.text = self.viewModel.playingTitle
        viewModel.playingAsset.generateThumbnail { image in
            DispatchQueue.main.async {
                if let image = image {
                    self.playingImageView.image = image
                    self.playingImageView.contentMode = .scaleToFill
                }
            }
        }
    }
    
    // MARK: - Observer
    
    private func addObserverForPlayEndTime(isRepeatPlay: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: self.assetPlayer.player.currentItem)
        
        if isRepeatPlay {
            NotificationCenter.default.addObserver(self, selector: #selector(rePlay), name: .AVPlayerItemDidPlayToEndTime, object: self.assetPlayer.player.currentItem)
            
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(playNextTrack), name: .AVPlayerItemDidPlayToEndTime, object: self.assetPlayer.player.currentItem)
        }
    }
    
    @objc func rePlay() {
        self.assetPlayer.player.seek(to: .zero)
        self.assetPlayer.play()
        self.addObserverForPlayEndTime(isRepeatPlay: playerControlView.isSelectedRepeatPlayButton)
    }
    
    private func changeHeaderTitle(_ title: String) {
        DispatchQueue.main.async {
            self.headerView.configure(title: self.viewModel.playingTitle, exitButtonIsHidden: false, sceneRotateButtonIsHidden: false)
            self.setPlayingInfo()
        }
    }
    
    @objc func playNextTrack() {
        
        self.viewModel.changeToNextMedia()

        let nextItem = AVPlayerItem(asset: viewModel.playingAsset)
        self.assetPlayer.player.replaceCurrentItem(with: nextItem)
        self.assetPlayer.play()

        changeHeaderTitle(viewModel.playingTitle)
        self.addObserverForPlayEndTime(isRepeatPlay: playerControlView.isSelectedRepeatPlayButton)
    }
    
    @objc func playPreviousTrack() {
        
        self.viewModel.changeToPreviousMedia()
        
        let previousItem = AVPlayerItem(asset: viewModel.playingAsset)
        self.assetPlayer.player.replaceCurrentItem(with: previousItem)
        self.assetPlayer.play()
        
        changeHeaderTitle(viewModel.playingTitle)
        self.addObserverForPlayEndTime(isRepeatPlay: playerControlView.isSelectedRepeatPlayButton)
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
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "duration",
        let duration = assetPlayer.player.currentItem?.duration.seconds,
        duration > 0.0 {
            
            self.playerControlView.configureTimeLabel(endTime: duration.durationText)
        }
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

    @objc func didTappedPlayerView(_ sender: UITapGestureRecognizer) {
        
        self.playerControlView.isHidden = !playerControlView.isHidden
        self.headerView.isHidden = !headerView.isHidden
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

        playerControlView.isSelectedRepeatPlayButton = !playerControlView.isSelectedRepeatPlayButton

        self.addObserverForPlayEndTime(isRepeatPlay: playerControlView.isSelectedRepeatPlayButton)
        
        if playerControlView.isSelectedRepeatPlayButton {
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

extension PlayerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.playList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerListTableViewCell", for: indexPath) as? PlayerListTableViewCell else { return UITableViewCell() }
        
        viewModel.playList[indexPath.row].asset.generateThumbnail { image in
            DispatchQueue.main.async {
                cell.configure(image: image)
            }
        }
        
        let title = self.viewModel.playList[indexPath.row].title
        let duration = self.viewModel.playList[indexPath.row].asset.duration.durationText
        
        cell.configure(name: title, duration: duration)
        
        let selectionColorView = UIView()
        selectionColorView.backgroundColor = .lightGray
        cell.selectedBackgroundView? = selectionColorView
    
        return cell
    }
}

extension PlayerViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)->CGFloat {
        return tableView.frame.height / 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.changeMedia(index: indexPath.row)
        let nextItem = AVPlayerItem(asset: viewModel.playingAsset)
        self.assetPlayer.player.replaceCurrentItem(with: nextItem)
        self.assetPlayer.play()
        self.setPlayingInfo()
        self.headerView.configure(title: self.viewModel.playingTitle, exitButtonIsHidden: false, sceneRotateButtonIsHidden: false)
        
        addObserverForPlayEndTime(isRepeatPlay: playerControlView.isSelectedRepeatPlayButton)
    }
}
