//
//  File.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/23/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//


import UIKit
class PhotoSelectorCell: UICollectionViewCell {
    
    let photoImageView:UIImageView  = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        photoImageView.anchorToView(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
