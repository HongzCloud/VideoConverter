//
//  AssetManager.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/12/05.
//

import Foundation
import AVFoundation

final class AssetManager {
    
    private(set) var assets: [AVAsset]
    private var directoryPath: Directory
    
    init(directoryPath: Directory) {
        self.directoryPath = directoryPath
        self.assets = AssetManager.loadAssets(directoryPath)
    }
    
    private class func loadAssets(_ directory: Directory) -> [AVAsset] {
        guard let urls = FileHelper.shared.urls(for: directory) else { return [] }
        var assetList = [AVAsset]()
        
        for url in urls {
            let asset = AVAsset(url: url)
            
            if asset.isPlayable {
                assetList.append(AVAsset(url: url))
            }
        }
        
        assetList.sort { one, other in
            let firstAsset = one as! AVURLAsset
            let secondAsset = other as! AVURLAsset
            
            return firstAsset.url.path < secondAsset.url.path
        }
        
        return assetList
    }
    
    func reloadAssets() {
        self.assets.removeAll()
        self.assets = AssetManager.loadAssets(directoryPath)
        self.assets.sort { one, other in
            let firstAsset = one as! AVURLAsset
            let secondAsset = other as! AVURLAsset
            return firstAsset.url.path < secondAsset.url.path
        }
    }
    
    func appendAsset(_ asset: AVAsset) {
        self.assets.append(asset)
    }
    
    func removeAsset(at index: Int, completion: (Bool) -> Void) {
        let asset = self.assets[index] as! AVURLAsset
        do {
            try FileManager.default.removeItem(at: asset.url)
            self.assets.remove(at: index)
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    func editAsset(at index: Int, name: String, completion: (Bool) -> Void) {
        let asset = self.assets[index] as! AVURLAsset
        let dicURL = self.directoryPath.rawValue
        let pathExtension = asset.url.pathExtension
        let newURL = dicURL.appendingPathComponent(name).appendingPathExtension(pathExtension)
 
        do {
            try FileManager.default.moveItem(at: asset.url, to: newURL)
            self.assets[index] = AVAsset(url: newURL)
            completion(true)
        } catch {
            completion(false)
        }
    }
}
