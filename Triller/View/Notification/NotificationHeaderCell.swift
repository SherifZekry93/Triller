//
//  HeaderCell.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/14/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
class NotificationHeaderCell: UICollectionViewCell {
    let noNotificationImage:UIImageView = {
        let noNotification = UIImageView()
        noNotification.image = #imageLiteral(resourceName: "alarm-bill")
        noNotification.contentMode = .scaleAspectFit
        return noNotification
    }()
    
    let noNotificationLabel:UILabel = {
        let label = UILabel()
        label.text = "You have no notification yet"
        label.textAlignment = .center
        return label
    }()
    lazy var stackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [noNotificationImage,noNotificationLabel])
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()
    {
        addSubview(stackView)
        stackView.anchorToView(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        noNotificationImage.anchorToView(size: .init(width: 0, height: 200))
    }
    
}
