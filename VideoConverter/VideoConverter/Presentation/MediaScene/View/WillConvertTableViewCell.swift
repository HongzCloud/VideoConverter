//
//  WillConvertTableViewCell.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/13.
//

import UIKit

class WillConvertTableViewCell: UITableViewCell {
    
    private let mediaView: MediaView = {
        let mediaView = MediaView()
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        return mediaView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUIObject()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUIObject()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setUIObject() {
        setMediaViewContraints()
    }
    
    private func setMediaViewContraints() {
        self.contentView.addSubview(mediaView)
        NSLayoutConstraint.activate([
            mediaView.topAnchor.constraint(equalTo: self.topAnchor),
            mediaView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mediaView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mediaView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func configure(image: UIImage?, name: String, duration: String) {
        self.mediaView.configure(image: image, name: name, duration: duration)
    }
    
    func setPlayButtonDelegate(_ delegate: MediaViewDelegate) {
        self.mediaView.delegate = delegate
    }
    
    func setMediaViewIndex(_ index: Int) {
        self.mediaView.setIndex(index)
    }
}
