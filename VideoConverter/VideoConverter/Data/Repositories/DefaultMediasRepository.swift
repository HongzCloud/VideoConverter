//
//  DefaultMediasRepository.swift
//  VideoConverter
//
//  Created by 오킹 on 2022/01/10.
//

import Foundation
import AVFoundation

protocol MediasRepository {
    func fetchMediaList(directory: Directory,
        completion: @escaping (Result<[Media], Error>) -> Void)
}

final class DefaultMoviesRepository {

}

extension DefaultMoviesRepository: MediasRepository {
    
    func fetchMediaList(directory: Directory, completion: @escaping (Result<[Media], Error>) -> Void) {
        
        guard let urls = FileHelper.shared.urls(for: directory) else { return }
        var medias = [Media]()
        
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
            medias.append(media)
        }
        
        completion(.success(medias))
    }
}
