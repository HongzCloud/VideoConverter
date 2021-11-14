//
//  MediaView.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/13.
//

import UIKit

class MediaView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    let mediaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let mediaNameLabel: UILabel = {
        let mediaNameLabel = UILabel()
        mediaNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return mediaNameLabel
    }()
    
    let mediaDurationLabel: UILabel = {
        let mediaDurationLabel = UILabel()
        mediaDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        return mediaDurationLabel
    }()
    
    let mediaPlayButton: UIButton = {
        let mediaPlayButton = UIButton()
        mediaPlayButton.translatesAutoresizingMaskIntoConstraints = false
        return mediaPlayButton
    }()
    
    let mediaShareButton: UIButton = {
        let mediaShareButton = UIButton()
        mediaShareButton.translatesAutoresizingMaskIntoConstraints = false
        return mediaShareButton
    }()
    
    var constant: CGFloat = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUIObject()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUIObject() {
        setMediaImageViewConstraints()
        setMediaShareButtonConstraints()
        setMediaPlayButtonConstraints()
        setMediaNameLabelConstraints()
        setMediaDurationLabelConstraints()
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
        mediaNameLabel.text = "sampleMP3.wav"
        self.addSubview(mediaNameLabel)
        NSLayoutConstraint.activate([
            mediaNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mediaNameLabel.leadingAnchor.constraint(equalTo: self.mediaImageView.trailingAnchor, constant: constant*2),
            mediaNameLabel.trailingAnchor.constraint(equalTo: mediaPlayButton.leadingAnchor, constant: -constant)
        ])
    }
    
    private func setMediaPlayButtonConstraints() {
        mediaPlayButton.backgroundColor = .green
        mediaPlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        
        self.addSubview(mediaPlayButton)
        NSLayoutConstraint.activate([
            mediaPlayButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mediaPlayButton.trailingAnchor.constraint(equalTo: self.mediaShareButton.leadingAnchor, constant: -constant),
            mediaPlayButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            mediaPlayButton.widthAnchor.constraint(equalTo: self.mediaPlayButton.heightAnchor)
        ])
    }
    
    private func setMediaShareButtonConstraints() {
        mediaShareButton.backgroundColor = .yellow
        mediaShareButton.setImage(UIImage(systemName: "arrowshape.turn.up.right.fill"), for: .normal)
        
        self.addSubview(mediaShareButton)
        NSLayoutConstraint.activate([
            mediaShareButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mediaShareButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -constant),
            mediaShareButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            mediaShareButton.widthAnchor.constraint(equalTo: self.mediaShareButton.heightAnchor)
        ])
    }
    
    private func setMediaDurationLabelConstraints() {
        mediaDurationLabel.text = "00:00"
        mediaDurationLabel.font = UIFont.systemFont(ofSize: 12)
        
        self.addSubview(mediaDurationLabel)
        NSLayoutConstraint.activate([
            mediaDurationLabel.bottomAnchor.constraint(equalTo: mediaImageView.bottomAnchor),
            mediaDurationLabel.leadingAnchor.constraint(equalTo: mediaImageView.trailingAnchor, constant: constant*2),
            mediaDurationLabel.trailingAnchor.constraint(equalTo: self.mediaPlayButton.leadingAnchor, constant: -5)
        ])
    }
}
