//
//  WillConvertTableViewCell.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/13.
//

import UIKit

class WillConvertTableViewCell: UITableViewCell {
    
    let mediaView: MediaView = {
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
    
    func setUIObject() {
        setMediaViewContraints()
    }
    
    func setMediaViewContraints() {
        self.addSubview(mediaView)
        NSLayoutConstraint.activate([
            mediaView.topAnchor.constraint(equalTo: self.topAnchor),
            mediaView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mediaView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mediaView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
