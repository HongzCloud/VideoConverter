//
//  PlayerListTableViewCell.swift
//  VideoConverter
//
//  Created by 오킹 on 2022/02/23.
//

import UIKit

class PlayerListTableViewCell: UITableViewCell {

    private let mediaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let mediaNameLabel: UILabel = {
        let mediaNameLabel = UILabel()
        mediaNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return mediaNameLabel
    }()
    
    private let mediaDurationLabel: UILabel = {
        let mediaDurationLabel = UILabel()
        mediaDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        return mediaDurationLabel
    }()
    
    private var constant: CGFloat = 5
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUIObject()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUIObject()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUIObject()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            mediaNameLabel.textColor = .black
            mediaDurationLabel.textColor = .black
        } else {
            mediaNameLabel.textColor = .white
            mediaDurationLabel.textColor = .white
        }
    
    }
    
    private func setUIObject() {
        setMediaImageViewConstraints()
        setMediaNameLabelConstraints()
        setMediaDurationLabelConstraints()
        self.backgroundColor = .black
    }
    
    private func setMediaImageViewConstraints() {
        mediaImageView.backgroundColor = .darkGray
        mediaImageView.layer.cornerRadius = 8
        mediaImageView.clipsToBounds = true
        
        self.addSubview(mediaImageView)
        NSLayoutConstraint.activate([
            mediaImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: constant),
            mediaImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: constant),
            mediaImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -constant),
            mediaImageView.widthAnchor.constraint(equalTo: self.mediaImageView.heightAnchor, multiplier: 1),
            mediaImageView.widthAnchor.constraint(lessThanOrEqualTo: self.mediaImageView.heightAnchor)
        ])
    }

    private func setMediaNameLabelConstraints() {
        mediaNameLabel.textColor = .white
        
        self.addSubview(mediaNameLabel)
        NSLayoutConstraint.activate([
            mediaNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mediaNameLabel.leadingAnchor.constraint(equalTo: self.mediaImageView.trailingAnchor, constant: constant*2),
            mediaNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -constant)
        ])
    }
    
    private func setMediaDurationLabelConstraints() {
        mediaDurationLabel.textColor = .white
        mediaDurationLabel.font = UIFont.systemFont(ofSize: 12)

        self.addSubview(mediaDurationLabel)
        NSLayoutConstraint.activate([
            mediaDurationLabel.bottomAnchor.constraint(equalTo: mediaImageView.bottomAnchor),
            mediaDurationLabel.topAnchor.constraint(equalTo: mediaNameLabel.bottomAnchor),
            mediaDurationLabel.leadingAnchor.constraint(equalTo: mediaImageView.trailingAnchor, constant: constant*2),
            mediaDurationLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
        ])
    }
    
    func configure(image: UIImage?) {
        if image != nil {
            mediaImageView.image = image
        } else {
            mediaImageView.image = UIImage(systemName: "music.note")
            mediaImageView.tintColor = .black
            mediaImageView.contentMode = .center
        }
    }
    
    func configure(name: String, duration: String) {
        self.mediaNameLabel.text = name
        self.mediaDurationLabel.text = duration
    }
}
