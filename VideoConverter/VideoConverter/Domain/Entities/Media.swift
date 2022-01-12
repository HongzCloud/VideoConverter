//
//  Media.swift
//  VideoConverter
//
//  Created by 오킹 on 2022/01/09.
// The `AVURLAsset` corresponding to an asset.

import Foundation
import AVFoundation

struct Media {
    private let urlAsset: AVURLAsset
    private var shouldPlay: Bool
    private let metadata: NowPlayableStaticMetadata

    init(metadata: NowPlayableStaticMetadata) {
        self.urlAsset = AVURLAsset(url: metadata.assetURL)
        self.shouldPlay = true
        self.metadata = metadata
    }
}
