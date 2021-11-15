//
//  CMTime+TimeToString.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/15.
//

import Foundation
import AVFoundation

extension CMTime {
    var durationText: String {
        let sInt = Int(seconds)
        let s: Int = sInt % 60
        let m: Int = (sInt / 60) % 60
        let h: Int = sInt / 3600
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
}
