//
//  DefaultMediaRepository.swift
//  VideoConverter
//
//  Created by 오킹 on 2022/01/10.
//

import Foundation
import AVFoundation

protocol MediaRepository {
    func fetchMediaList(directory: Directory,
        completion: @escaping (Result<[Media], Error>) -> Void)
}

final class DefaultMediaRepository { }

extension DefaultMediaRepository: MediaRepository {
    
    func fetchMediaList(directory: Directory, completion: @escaping (Result<[Media], Error>) -> Void) {
        
        guard let urls = FileHelper.shared.urls(for: directory) else { return }
        var mediaList = [Media]()
        
        for url in urls {
            let asset = AVAsset(url: url) as! AVURLAsset
            let title = asset.url.lastPathComponent
            let metadata = NowPlayableStaticMetadata(assetURL: url,
                                      isLiveStream: false,
                                      title: title,
                                      artist: nil,
                                      artwork: nil,
                                      albumArtist: nil,
                                      albumTitle: nil)
            
            let media = Media(metadata: metadata)
            mediaList.append(media)
        }
        
        completion(.success(mediaList))
    }
}
