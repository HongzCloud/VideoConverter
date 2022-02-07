//
//  PlayerViewModel.swift
//  VideoConverter
//
//  Created by 오킹 on 2022/02/06.
//

import Foundation
import AVFoundation

protocol PlayerViewModelInput {
    func changeToNextMedia()
    func changeToPreviousMedia()
}

protocol PlayerViewModelOutput {
    var title: String { get }
    var asset: AVAsset { get }
}

protocol PlayerViewModel: PlayerViewModelInput, PlayerViewModelOutput { }

final class DefaultPlayerViewModel: PlayerViewModel {
 
    var title: String
    var asset: AVAsset
    
    private var media: Media
    private var playList: [Media]
    private var playingIndex: Int
    
    static let shared = DefaultPlayerViewModel()
    
    init() {
        self.media = .init(metadata: .init(assetURL: URL(fileURLWithPath: ""), isLiveStream: false, title: "", artist: nil, artwork: nil, albumArtist: nil, albumTitle: nil))
        self.title = ""
        self.playList = []
        self.playingIndex = 0
        self.asset = AVAsset(url: URL(fileURLWithPath: ""))
    }
    
    func setMedia(playList: [URL], playingIndex: Int) {
    
        let asset = AVAsset(url: playList[playingIndex])
        let avURLAsset = asset as! AVURLAsset
        let title = avURLAsset.url.lastPathComponent
        
        self.media = Media(metadata: .init(assetURL: avURLAsset.url, isLiveStream: false, title: title, artist: nil, artwork: nil, albumArtist: nil, albumTitle: nil))
        self.title = title
        self.playingIndex = playingIndex
        self.asset = asset
        self.playList = playList.map{
            Media(metadata: .init(assetURL: $0, isLiveStream: false, title: $0.lastPathComponent, artist: nil, artwork: nil, albumArtist: nil, albumTitle: nil))
        }
    }
}

extension DefaultPlayerViewModel {
    func changeToNextMedia() {
        self.playingIndex += 1
        
        if playingIndex >= playList.count {
            self.playingIndex = 0
        } 
        
        self.media = playList[playingIndex]
        self.title = media.metadata.title
        self.asset = AVAsset(url: media.metadata.assetURL)
    }
    
    func changeToPreviousMedia() {
        self.playingIndex -= 1
        
        if playingIndex < 0 {
            self.playingIndex = (playList.count - 1)
        }
        
        self.media = playList[playingIndex]
        self.title = media.metadata.title
        self.asset = AVAsset(url: media.metadata.assetURL)
    }
}
