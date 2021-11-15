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
    var willConvertMedia = [AVAsset]()
    @IBOutlet weak var willConvertTableView: UITableView!
    let convertView = ConvertView()
    let pickerViewData = ["wav", "caf", "flac", "aac", "mp3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.willConvertTableView.delegate = self
        self.willConvertTableView.dataSource = self
        self.willConvertTableView.register(WillConvertTableViewCell.self, forCellReuseIdentifier: "WillConvertTableViewCell")
        
        if let files = getFiles(.willConvert) {
            willConvertMedia = files
            setConvertView()
        }
    }
    
    func setConvertView() {
        convertView.translatesAutoresizingMaskIntoConstraints = false
        convertView.backgroundColor = .lightGray
        convertView.didConvertedExtensionNamePickerView.delegate = self
        convertView.didConvertedExtensionNamePickerView.dataSource = self
        convertView.isHidden = true
        
        self.view.addSubview(convertView)
        NSLayoutConstraint.activate([
            self.convertView.bottomAnchor.constraint(equalTo: self.willConvertTableView.bottomAnchor),
            self.convertView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.convertView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.convertView.heightAnchor.constraint(equalTo: self.willConvertTableView.heightAnchor, multiplier: 1/8)
        ])
    }
    
    func getFiles(_ directory: Directory) -> [AVAsset]? {
        guard let urls = FileHelper().urls(for: directory) else { return nil }
        var avAssests = [AVAsset]()
        
        for url in urls {
            avAssests.append(AVAsset(url: url))
        }
        
        return avAssests
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

extension WillConvertViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return willConvertMedia.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WillConvertTableViewCell") as? WillConvertTableViewCell else { return UITableViewCell() }
        let file = willConvertMedia[indexPath.row] as! AVURLAsset
        cell.configure(image: nil, name: file.url.lastPathComponent, duration: file.duration.durationText)
        return cell
    }
}

extension WillConvertViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)->CGFloat {
        return tableView.frame.height / 10
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let file = willConvertMedia[indexPath.row] as! AVURLAsset
        convertView.isHidden = false
        convertView.configure(currentFormat: file.url.pathExtension)
    }
}

extension WillConvertViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("select=\(row)")
    }
}
