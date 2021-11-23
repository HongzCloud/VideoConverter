//
//  VideoListViewController.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/17.
//

import UIKit
import Photos

class VideoListViewController: UIViewController {

    @IBOutlet weak var videoListColletcionView: UICollectionView!
    private let header = HeaderView()
    private let sectionInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    private var videos = [PHAsset]()
    private var selectedCellIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoListColletcionView.dataSource = self
        videoListColletcionView.delegate = self
        videoListColletcionView.register(VideoListCollectionViewCell.self, forCellWithReuseIdentifier: "VideoListCollectionViewCell")
        self.header.delegate = self
        setUIObject()
        getVideos { [self] in
            self.videoListColletcionView.reloadData()
        }
    }
    
    private func setUIObject() {
        setHeaderConstraints()
        setVideoListCollectionView()
    }
    
    private func setHeaderConstraints() {
        self.header.configure(title: "비디오 목록",exitButtonIsHidden: false, saveButtonIsHidden: false)
        self.header.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(header)
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.header.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.header.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/14),
            self.header.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.header.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func setVideoListCollectionView() {
        self.videoListColletcionView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.videoListColletcionView.topAnchor.constraint(equalTo: self.header.bottomAnchor),
            self.videoListColletcionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.videoListColletcionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.videoListColletcionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func getVideos(completion: () -> Void) {
        let fetchOption = PHFetchOptions()
        fetchOption.includeAssetSourceTypes = [.typeUserLibrary]
        let allVideos = PHAsset.fetchAssets(with: .video, options: fetchOption)
        
        allVideos.enumerateObjects({ phAsset, pointer,_  in
            self.videos.append(phAsset)
        })
        completion()
    }
}

extension VideoListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoListCollectionViewCell", for: indexPath) as? VideoListCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.configure(image: videos[indexPath.row].thumbnailImage, duration: videos[indexPath.row].duration.durationText)
            
        return cell
    }
}

extension VideoListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let itemsPerRow: CGFloat = 3
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        let itemsPerColumn: CGFloat = 6
        let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight = (height - heightPadding) / itemsPerColumn
        
        return CGSize(width: cellWidth, height: cellHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCellIndex = indexPath
    }
}

extension VideoListViewController: CustomHeaderViewDelegate {
    func didTappedSaveButton() {
        guard let indexPath = self.selectedCellIndex else { return }
        
        PHImageManager.default().requestAVAsset(forVideo: self.videos[indexPath.row], options: PHVideoRequestOptions(), resultHandler: { (asset, audioMix, info) -> Void in
            if let asset = asset as? AVURLAsset {
                let videoData = NSData(contentsOf: asset.url)
                
                // optionally, write the video to the temp directory
                let videoPath = FileHelper().createFileURL(asset.url.lastPathComponent, in: .willConvert).path
                print(videoPath)
                let videoURL = NSURL(fileURLWithPath: videoPath)
                let writeResult = videoData?.write(to: videoURL as URL, atomically: true)
                
                print(videoData)
                print(writeResult)
                if let writeResult = writeResult {
                    print("success")
                    DispatchQueue.main.sync {
                        self.didTappedExitButton()
                    }
                }
                else {
                    print("failure")
                }
            }
        })
    }
    
    func didTappedExitButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
