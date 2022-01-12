//
//  PlayerView.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/21.
//

import UIKit
import AVFoundation

class PlayerView: UIView {

    var player: AVPlayer? {
        get { return playerLayer.player }
        set { playerLayer.player = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .black
    }
    
    var playerLayer: AVPlayerLayer {
        
        guard let playerLayer = layer as? AVPlayerLayer
            else { fatalError("AssetPlayerView player layer must be an AVPlayerLayer") }
        
        return playerLayer
    }

    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
