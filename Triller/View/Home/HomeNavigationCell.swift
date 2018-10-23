//
//  HomeNavigationCell.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/17/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
class HomeNavigationCell: UICollectionViewCell {
    let menuImage:UIImageView = {
       let image = UIImageView()
       image.image = #imageLiteral(resourceName: "nav_more_icon").withRenderingMode(.alwaysTemplate)
       image.tintColor = .black
        image.contentMode = .scaleAspectFit
       return image
    }()
    let logoImage:UIImageView = {
       let image = UIImageView()
        image.image = #imageLiteral(resourceName: "logo-empty")
        image.contentMode = .scaleAspectFit
        return image
    }()
    lazy var stackContainer:UIStackView = {
       let stack = UIStackView(arrangedSubviews: [logoImage,fillingView,menuImage])
       return stack
    }()
    let fillingView = UIView()
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        addSubview(stackContainer)
        stackContainer.anchorToView(top: topAnchor, leading: leftAnchor, bottom: bottomAnchor, trailing: rightAnchor,padding: .init(top: 3, left: 8, bottom: 3, right: 0))
        menuImage.anchorToView( size: .init(width: 38, height: 38))
        logoImage.anchorToView( size: .init(width: 60, height: 38))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
