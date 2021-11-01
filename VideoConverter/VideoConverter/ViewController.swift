//
//  ViewController.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/10/20.
//

import UIKit
import AVFoundation
import Photos
class ViewController: UIViewController {

    var allVideo = [AVAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileHelper().createInputOutputDirectory())
 
        let sampleVideoMP4 = Bundle.main.url(forResource: "sampleVideoMP4", withExtension: "mp4")
        let testAVAsset = AVAsset(url: sampleVideoMP4!)
        
        self.writeAssetToM4A(output: FileHelper().createOutputFileURL("sampleVideoM4A.m4a"), avAsset: testAVAsset)
    }
    
    func getVideos(completion: @escaping () -> Void ) {
        var phAssets = [PHAsset]()
        var avAssets = [AVAsset]()
        let fetchOption = PHFetchOptions()
        fetchOption.includeAssetSourceTypes = [.typeUserLibrary]
        let allVideos = PHAsset.fetchAssets(with: .video, options: fetchOption)
        
        allVideos.enumerateObjects({ phAsset, pointer,_  in
            phAssets.append(phAsset)
            
        })
        
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        
        for video in phAssets {
            PHCachingImageManager().requestAVAsset(forVideo: video, options: options) { (avAsset, _, _ ) in
                if let asset = avAsset {
                    self.allVideo.append(avAsset!)
                }
            }
        }
        completion()
    }

    
    func writeAssetToM4A(output: URL, avAsset: AVAsset) {
        avAsset.writeAudio(output, completion: { result, error in
            print(result)
            print(error)
        })
    }
}



