//
//  PlayerViewController.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/21.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {

    private var playerView: PlayerView!
    private var playerControlView: PlayerControlView!
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    private var isPlaying = false
    private var headerView = HeaderView()
    private var orientation: UIInterfaceOrientation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPlayerView()
        setHeaderView()
        setPlayerControlView()
        addTimeObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        orientation = UIInterfaceOrientation.portrait
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.playerLayer.frame = playerView.bounds
    }
    
    static func create(with url: URL) -> PlayerViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as? PlayerViewController else {
            return PlayerViewController()
        }
        vc.setPlayer(url: url)
     
        return vc
    }
    
    func setPlayer(url: URL) {
        self.player = AVPlayer(url: url)
        self.playerLayer = AVPlayerLayer(player: player)
        self.playerLayer.videoGravity = .resizeAspect
        self.player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new,.initial], context: nil)
    }
        
    private func setHeaderView() {
        self.headerView = HeaderView()
        self.headerView.delegate = self
        self.headerView.alpha = 0.4
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
        playerControlView.isHidden = !playerControlView.isHidden
        headerView.isHidden = !headerView.isHidden
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
                                                      endTime: nil)
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player.currentItem?.duration.seconds, duration > 0.0 {
            self.playerControlView.configureTimeLabel(endTime: duration.durationText)
        }
    }

    @objc func exitVC(_ sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PlayerViewController: PlayerControlViewDelegate {

    func didTappedPlayButton(_ button: UIButton) {
        if isPlaying {
            button.setImage(UIImage(systemName: "play.fill"), for: .normal)
            player.pause()
        } else {
            button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            player.play()
        }
        
        isPlaying = !isPlaying
    }

    func didTappedBackwardButton() {
        let currentTime = CMTimeGetSeconds(player.currentTime())
        var newTime = currentTime - 10.0
        
        if newTime < 0 {
            newTime = 0
        }
        
        let time = CMTimeMake(value: Int64(newTime * 1000), timescale: 1000)
        player.seek(to: time)
    }
    
    func didTappedForwardButton() {
        let currentTime = CMTimeGetSeconds(player.currentTime())
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
}

extension PlayerViewController: CustomHeaderViewDelegate {
    
    func didTappedSceneRotateButton() {
        if orientation == UIInterfaceOrientation.landscapeRight {
            orientation = UIInterfaceOrientation.portrait
        } else {
            orientation = UIInterfaceOrientation.landscapeRight
        }
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
    }
    
    func didTappedExitButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
