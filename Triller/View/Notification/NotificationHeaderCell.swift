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
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupViews()
    }
    let notificationLabel:UILabel = {
        let label = UILabel()
        label.text = "  Notification"
        return label
    }()
    
    lazy var navigationContainer:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [notificationLabel])
        return stack
    }()
    
    let navigationBackgroundView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let navSeparator:UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return separator
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews()
    {
        addSubview(navigationBackgroundView)
        navigationBackgroundView.addBottomBorderWithColor(color: .red, width: 100)
        addSubview(navigationContainer)
        addSubview(navSeparator)
        
        
        navigationBackgroundView.anchorToView(top: navigationContainer.topAnchor, left: navigationContainer.leftAnchor, bottom: navigationContainer.bottomAnchor, right: navigationContainer.rightAnchor)
        navSeparator.anchorToView(top: navigationBackgroundView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, padding: .zero, size: .init(width: 0, height: 1), centerH: false, centerV: false)
        navigationContainer.anchorToView(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor,size: .init(width: 0, height: 44))
        
        addSubview(stackView)
        
        stackView.anchorToView(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,padding: .init(top: 25 + 44 + 1, left: 0, bottom: 0, right: 0))
    }
}
