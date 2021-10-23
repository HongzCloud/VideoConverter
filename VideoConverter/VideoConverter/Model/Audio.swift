//
//  Audio.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/10/21.
//

import Foundation
import AVFoundation

struct Audio {
    private(set) var formatID = kAudioFormatLinearPCM
    private(set) var sampleRate: UInt32 = 44100
    private(set) var bitRate: UInt32 = 0
    private(set) var bitDepth: UInt32 = 0
    private(set) var channel: UInt32 = 0
    private(set) var url: URL
    
    init(url: URL) {
        self.url = url
    }
}

enum FileFormat {
    case wav
    case mp3
    case aac
    case flac
    case caf
    
    var rawValue: AudioFormatID {
        switch self {
        case .aac:
            return kAudioFormatMPEG4AAC
        case .mp3:
            return kAudioFormatMPEGLayer3
        case .wav:
            return kAudioFormatLinearPCM
        case .flac:
            return kAudioFormatFLAC
        case .caf:
            return kAudioFormatLinearPCM
        }
    }
}

enum SampleRate: UInt32 {
    case m44k = 44100
    case m22k = 22050
    case m11k = 11025
    case m08k = 8000
}

enum Channel: UInt32 {
    case mono = 1
    case stereo = 2
}

enum BitRate: UInt32 {
    case m320k = 320000
    case m192k = 192000
}

enum BitPerChannel: UInt32 {
    case m16 = 16
    case m24 = 24
}
