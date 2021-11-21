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
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
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
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        player.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.playerLayer.frame = playerView.bounds
    }
    
    private func setUIObject() {
        setPlayerViewConstraints()
        setTempButtonConstraints()
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
    
    private func setTempButtonConstraints() {
        self.view.addSubview(tempButton)
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.tempButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            self.tempButton.topAnchor.constraint(equalTo: safeArea.topAnchor)
        ])
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
