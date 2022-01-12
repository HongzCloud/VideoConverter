//
//  PHAsset+Thumbnail.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/20.
//
import UIKit
import Photos

extension PHAsset {
    var thumbnailImage : UIImage {
        get {
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var thumbnail = UIImage()
            option.isSynchronous = true
            manager.requestImage(for: self, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                if let result = result {
                    thumbnail = result
                }
            })
            return thumbnail
        }
    }
}
