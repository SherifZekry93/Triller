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
        noNotification.image = #imageLiteral(resourceName: "alarm-bell")
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
        stack.distribution = .fillEqually
        return stack
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews()
    {
        addSubview(stackView)
        stackView.anchorToView(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,padding: .init(top: 50, left: 0, bottom: 0, right: 0))
    }
}