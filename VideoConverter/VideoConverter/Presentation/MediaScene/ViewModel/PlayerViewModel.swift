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
    func changeMedia(index: Int)
}

protocol PlayerViewModelOutput {
    var playingTitle: String { get }
    var playingAsset: AVAsset { get }
    var playingIndex: Int { get }
    var playList: [PlayListItemViewModel] { get }

}

protocol PlayerViewModel: PlayerViewModelInput, PlayerViewModelOutput { }

final class DefaultPlayerViewModel: PlayerViewModel {
 
    var playingTitle: String
    var playingAsset: AVAsset
    var playList: [PlayListItemViewModel]
    var playingIndex: Int
    
    private var media: Media
    private var mediaList: [Media]
    
    static let shared = DefaultPlayerViewModel()
    
    init() {
        self.media = .init(metadata: .init(assetURL: URL(fileURLWithPath: ""), isLiveStream: false, title: "", artist: nil, artwork: nil, albumArtist: nil, albumTitle: nil))
        self.playingTitle = ""
        self.mediaList = []
        self.playingIndex = 0
        self.playingAsset = AVAsset(url: URL(fileURLWithPath: ""))
        self.playList = []
    }
    
    func setMedia(playList: [URL], playingIndex: Int) {
    
        let asset = AVAsset(url: playList[playingIndex])
        let avURLAsset = asset as! AVURLAsset
        let title = avURLAsset.url.lastPathComponent
        
        self.media = Media(metadata: .init(assetURL: avURLAsset.url, isLiveStream: false, title: title, artist: nil, artwork: nil, albumArtist: nil, albumTitle: nil))
        self.playingTitle = title
        self.playingIndex = playingIndex
        self.playingAsset = asset
        self.mediaList = playList.map{
            Media(metadata: .init(assetURL: $0, isLiveStream: false, title: $0.lastPathComponent, artist: nil, artwork: nil, albumArtist: nil, albumTitle: nil))
        }
        self.playList = mediaList.map { PlayListItemViewModel(asset: AVAsset(url: $0.metadata.assetURL), title: $0.metadata.title) }
    }
    
    func changeMedia(index: Int) {
        self.media = mediaList[index]
        self.playingTitle = media.metadata.title
        self.playingAsset = AVAsset(url: media.metadata.assetURL)
        self.playingIndex = index
    }
}

extension DefaultPlayerViewModel {
    func changeToNextMedia() {
        self.playingIndex += 1
        
        if playingIndex >= mediaList.count {
            self.playingIndex = 0
        } 
        
        self.media = mediaList[playingIndex]
        self.playingTitle = media.metadata.title
        self.playingAsset = AVAsset(url: media.metadata.assetURL)
    }
    
    func changeToPreviousMedia() {
        self.playingIndex -= 1
        
        if playingIndex < 0 {
            self.playingIndex = (mediaList.count - 1)
        }
        
        self.media = mediaList[playingIndex]
        self.playingTitle = media.metadata.title
        self.playingAsset = AVAsset(url: media.metadata.assetURL)
    }
}

struct PlayListItemViewModel: Hashable {
    var asset: AVAsset
    var title: String
}
