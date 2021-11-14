//
//  ViewController.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/10/20.
//

import UIKit
import AVFoundation
import Photos
class WillConvertViewController: UIViewController {

    var allVideo = [AVAsset]()
    @IBOutlet weak var willConvertTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.willConvertTableView.delegate = self
        self.willConvertTableView.dataSource = self
        self.willConvertTableView.register(WillConvertTableViewCell.self, forCellReuseIdentifier: "WillConvertTableViewCell")
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
}

extension UIViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WillConvertTableViewCell") as? WillConvertTableViewCell else { return UITableViewCell() }
        return cell
    }
}

extension UIViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath)->CGFloat {
       return 80
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)->CGFloat {
        return tableView.frame.height / 10
    }
}
