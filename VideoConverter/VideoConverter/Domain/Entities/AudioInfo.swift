//
//  Audio.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/10/21.
//

import Foundation
import AVFoundation

enum FileFormat: CaseIterable {
    case wav
    case mp3
    case m4a
    case caf
    
    var rawValue: AudioFormatID {
        switch self {
        case .m4a:
            return kAudioFormatMPEG4AAC
        case .mp3:
            //video -> wav(pcm) -> mp3
            return kAudioFormatLinearPCM
        case .wav:
            return kAudioFormatLinearPCM
        case .caf:
            return kAudioFormatLinearPCM
        }
    }
    
    var text: String {
        switch self {
        case .m4a:
            return "m4a"
        case .caf:
            return "caf"
        case .mp3:
            return "mp3"
        case .wav:
            return "wav"
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
    case m32 = 32
}
