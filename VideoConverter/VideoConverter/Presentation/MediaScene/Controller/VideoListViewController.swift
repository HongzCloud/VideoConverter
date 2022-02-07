//
//  VideoListViewController.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/17.
//

import Toast_Swift
import UIKit
import PhotosUI

protocol VideoSavingDelegate: AnyObject {
    func startVideoSaving()
    func completeVideoSaving(asset: AVAsset)
}

class VideoListViewController: UIViewController, PHPhotoLibraryChangeObserver {

    @IBOutlet weak var videoListColletcionView: UICollectionView!
    private var header: HeaderView!
    private var sectionInsets: UIEdgeInsets!
    private var videos = [PHAsset]()
    private var selectedCellIndex: IndexPath?
    private var selectMorePhotos: SelectMorePhotosButton!
    
    weak var coordinator: VideoSavingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeader()
        setVideoListCollectionView()
        setSelectMorePhotosButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        requestPHPhotoLibraryAuthorization {
            self.loadVideos()
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
        self.header.configure(title: "비디오 보관함".localized(), exitButtonIsHidden: false, saveButtonIsHidden: false)
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
    
    private func setSelectMorePhotosButton() {
        self.selectMorePhotos = SelectMorePhotosButton()
        self.selectMorePhotos.translatesAutoresizingMaskIntoConstraints = false
        self.selectMorePhotos.addTarget(self, action: #selector(didTappedSelectMorePhotosButton), for: .touchUpInside)
        
        self.view.addSubview(selectMorePhotos)
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.selectMorePhotos.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 1/6),
            self.selectMorePhotos.heightAnchor.constraint(equalTo: self.selectMorePhotos.widthAnchor),
            self.selectMorePhotos.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20)
        ])
        
        let constraint = NSLayoutConstraint(item: selectMorePhotos as Any,
                                            attribute: .centerY,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .bottom,
                                            multiplier: 2/3,
                                            constant: 0)
        constraint.isActive = true
    }
    
    @objc private func didTappedSelectMorePhotosButton() {
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) {
            (status) in
            switch status {
            case .limited:
                DispatchQueue.main.async {
                    PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
                }
            case .denied:
                DispatchQueue.main.async {
                    self.showPhotoPermissionAlert()
                }
            default: break
            }
        }
    }
    
    private func requestPHPhotoLibraryAuthorization(completion: @escaping () -> Void) {
    
        PHPhotoLibrary.requestAuthorization(for: .readWrite) {
            (status) in
            switch status {
            case .limited:
                PHPhotoLibrary.shared().register(self)
                completion()
            case .authorized:
                DispatchQueue.main.async {
                    self.selectMorePhotos.isHidden = true
                }
                completion()
            default:
                self.showPhotoPermissionAlert()
            }
        }
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        self.loadVideos()
        
        if self.videos.isEmpty {
            DispatchQueue.main.async {
                var style = ToastStyle()
                style.messageColor = .greenAndMint!
                
                self.view.makeToast("비디오만 가져올 수 있습니다.".localized(),
                                    duration: 2,
                                    point: CGPoint(x: self.view.center.x, y: self.view.center.y * 2/5),
                                    title: nil,
                                    image: nil,
                                    style: style,
                                    completion: nil)
            }
        }
    }
    
    private func loadVideos() {
        let fetchOption = PHFetchOptions()
        fetchOption.includeAssetSourceTypes = [.typeUserLibrary]
        let allVideos = PHAsset.fetchAssets(with: .video, options: fetchOption)
        
        self.videos.removeAll()
        
        allVideos.enumerateObjects({ phAsset, pointer,_  in
            self.videos.append(phAsset)
        })
        
        DispatchQueue.main.async {
            self.videoListColletcionView.reloadData()
        }
    }
    
    private func showPhotoPermissionAlert() {
        
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: "사진첩 권한 요청".localized(), message: "사용자의 사진첩에 있는 동영상을 변환하기 위해 사진첩 권한 허용이 필요합니다.".localized(), preferredStyle: .alert)
            
            let editPermission = UIAlertAction(title: "이동".localized(), style: .default) { action in
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings,
                                              options: [:],
                                              completionHandler: nil)
                }
            }
            
            let cancel = UIAlertAction(title: "취소".localized(), style: .cancel, handler: nil)
            
            alert.addAction(editPermission)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
        }
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
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.selectMorePhotos.alpha = 0.8
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.selectMorePhotos.alpha = 0.3
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
