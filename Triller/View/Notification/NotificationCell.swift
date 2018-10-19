//
//  NormalNotificationCell.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/18/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
class NotificationCell: UICollectionViewCell
{
    let profileImage:UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .yellow
        image.layer.cornerRadius = 25
        image.clipsToBounds = true
        image.image = #imageLiteral(resourceName: "profile-imag")
        return image
    }()
    
    let notificationContentDateLabel:UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Sherif Zekry", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 17)])
        attributedText.append(NSAttributedString(string: "\nDate", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)]))
            label.attributedText = attributedText
        label.numberOfLines = -1
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame:frame)
        addSubview(profileImage)
        addSubview(notificationContentDateLabel)
        profileImage.anchorToView(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, padding:.init(top: 12, left: 12, bottom: 12, right: 12), size: .init(width: 50, height: 50))
        notificationContentDateLabel.anchorToView(top: profileImage.topAnchor, left: profileImage.rightAnchor, padding: .init(top: 6, left: 12, bottom: 0, right: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
