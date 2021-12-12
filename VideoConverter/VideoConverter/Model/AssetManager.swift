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
        guard let urls = FileHelper().urls(for: directory) else { return [] }
        var assetList = [AVAsset]()
        
        for url in urls {
            assetList.append(AVAsset(url: url))
        }
        
        return assetList
    }
    
    func reloadAssets() {
        self.assets.removeAll()
        self.assets = AssetManager.loadAssets(directoryPath)
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
