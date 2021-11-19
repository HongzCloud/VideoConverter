//
//  VideoListViewController.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/17.
//

import UIKit

class VideoListViewController: UIViewController {

    @IBOutlet weak var videoListColletcionView: UICollectionView!
    private let header = WillConvertTableHeaderView()
    private let sectionInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoListColletcionView.dataSource = self
        videoListColletcionView.delegate = self
        videoListColletcionView.register(VideoListCollectionViewCell.self, forCellWithReuseIdentifier: "VideoListCollectionViewCell")
        setUIObject()
    }
    
    private func setUIObject() {
        setHeaderConstraints()
        setVideoListCollectionView()
    }
    
    private func setHeaderConstraints() {
        self.header.configure(title: "비디오 목록", photoLibraryIsHidden: true)
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
}

extension VideoListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoListCollectionViewCell", for: indexPath) as? VideoListCollectionViewCell
        else { return UICollectionViewCell() }
        
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
}
