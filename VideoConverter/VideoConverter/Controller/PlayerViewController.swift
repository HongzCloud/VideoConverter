//
//  PlayerViewController.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/21.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {

    private var playerView = PlayerView()
    private var playerControlView = PlayerControlView()
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    private var isPlaying = false
    private var tempButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(exitVC), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIObject()
        addTimeObserver()
        self.playerControlView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTappedPlayerView(_:)))
        self.playerView.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTappedPlayerView(_ sender: UITapGestureRecognizer) {
        playerControlView.isHidden = !playerControlView.isHidden
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.playerLayer.frame = playerView.bounds
    }
    
    private func setUIObject() {
        setPlayerViewConstraints()
        setTempButtonConstraints()
        setPlayerControlViewConstraints()
    }
    
    private func setPlayerViewConstraints() {
        self.playerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playerView)
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.playerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.playerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.playerView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.playerView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.playerView.heightAnchor.constraint(equalTo: self.playerView.widthAnchor, multiplier: 9/16)
        ])
    }
    
    private func setPlayerControlViewConstraints() {
        playerControlView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playerControlView)
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.playerControlView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            self.playerControlView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.playerControlView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.playerControlView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.15)
        ])
    }
    
    private func setTempButtonConstraints() {
        self.view.addSubview(tempButton)
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.tempButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            self.tempButton.topAnchor.constraint(equalTo: safeArea.topAnchor)
        ])
    }
    
    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.6, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        _ = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: {
            [weak self] time in
            guard let currentItem = self?.player.currentItem else { return }
            self?.playerControlView.configureSlider(maxValue: Float(currentItem.duration.seconds),
                                                    minValue: 0,
                                                    value: Float(currentItem.currentTime().seconds))
        })
    }

    @objc func exitVC(_ sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setPlayer(url: URL) {
        self.player = AVPlayer(url: url)
        
        self.playerLayer = AVPlayerLayer(player: player)
        self.playerLayer.videoGravity = .resize
        
        self.playerView.layer.addSublayer(playerLayer)
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
