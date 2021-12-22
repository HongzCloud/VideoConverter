//
//  VideoListViewController.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/17.
//

import Toast_Swift
import UIKit
import Photos


protocol VideoSavingDelegate: AnyObject {
    func startVideoSaving()
    func completeVideoSaving(asset: AVAsset)
}

class VideoListViewController: UIViewController {

    @IBOutlet weak var videoListColletcionView: UICollectionView!
    private var header: HeaderView!
    private var sectionInsets: UIEdgeInsets!
    private var videos = [PHAsset]()
    private var selectedCellIndex: IndexPath?
    
    weak var coordinator: VideoSavingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeader()
        setVideoListCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .denied:
            showPhotoPermissionAlert()
        default:
            self.loadVideos {
                self.videoListColletcionView.reloadData()
            }
        }
    }
    
    static func create() -> VideoListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "VideoListViewController") as? VideoListViewController else {
            return VideoListViewController()
        }
        return vc
    }
    
    private func setHeader() {
        self.header = HeaderView()
        self.header.delegate = self
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
        self.sectionInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        //pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refresh(_:)), for: .valueChanged)
        self.videoListColletcionView.refreshControl = refreshControl
        
        self.videoListColletcionView.dataSource = self
        self.videoListColletcionView.delegate = self
        self.videoListColletcionView.register(VideoListCollectionViewCell.self, forCellWithReuseIdentifier: "VideoListCollectionViewCell")
        self.videoListColletcionView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.videoListColletcionView.topAnchor.constraint(equalTo: self.header.bottomAnchor),
            self.videoListColletcionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.videoListColletcionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.videoListColletcionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    @objc func refresh(_ control: UIRefreshControl) {
        self.videoListColletcionView.alpha = 0.5
        self.loadVideos {
            self.videoListColletcionView.reloadData()
            control.endRefreshing()
            UIView.animate(withDuration: 1, animations: {
                self.videoListColletcionView.alpha = 1
            }, completion: nil)
        }
    }
    
    private func loadVideos(completion: () -> Void) {
        let fetchOption = PHFetchOptions()
        fetchOption.includeAssetSourceTypes = [.typeUserLibrary]
        let allVideos = PHAsset.fetchAssets(with: .video, options: fetchOption)
        
        self.videos.removeAll()
        
        allVideos.enumerateObjects({ phAsset, pointer,_  in
            self.videos.append(phAsset)
        })
        
        completion()
    }
    
    private func showPhotoPermissionAlert() {
        
        let alert = UIAlertController(title: "사진첩 권한 요청", message: "사진첩 권한 허용이 필요합니다.", preferredStyle: .alert)
        
        let editPermission = UIAlertAction(title: "이동", style: .default) { action in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings,
                                          options: [:],
                                          completionHandler: nil)
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(editPermission)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
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
        let options = PHVideoRequestOptions()
        options.deliveryMode = .automatic
        options.version = .original
        options.isNetworkAccessAllowed = true
        PHImageManager.default().requestExportSession(forVideo: self.videos[indexPath.row], options: options, exportPreset: AVAssetExportPresetPassthrough) { (exportSession, info) in
            guard let session = exportSession, let asset = session.asset as? AVURLAsset else { return }
            session.outputURL = FileHelper.shared.createFileURL(asset.url.lastPathComponent, in: .willConvert)
            session.outputFileType = AVFileType.mp4
                
            self.coordinator?.startVideoSaving()
            
            session.exportAsynchronously {
                DispatchQueue.main.async {
                    if let outURL = session.outputURL {
                        let asset = AVAsset(url: outURL)
                        self.coordinator?.completeVideoSaving(asset: asset)
                    }
                }
                
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func didTappedExitButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
