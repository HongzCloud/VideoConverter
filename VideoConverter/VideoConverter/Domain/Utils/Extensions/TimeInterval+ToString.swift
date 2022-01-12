//
//  TimeInterval+ToString.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/20.
//

import Foundation

extension TimeInterval {
    var durationText: String {
        let sInt = Int(self)
        let s: Int = sInt % 60
        let m: Int = (sInt / 60) % 60
        let h: Int = sInt / 3600
        
        if h > 0 {
            return String(format: "%02d:%02d:%02d", h, m, s)
        } else {
            return String(format: "%02d:%02d", m, s)
        }
    }
}
