//
//  CommentCell.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/14/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
class CommentCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let profileHashTagImage:UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "profile-imag")
        return image
    }()
    
    let userNameHashTagLabel:UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Sherif Zekry", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 18)])
        label.numberOfLines = -1
        label.attributedText = attributedText
        return label
    }()
    lazy var mainStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileHashTagImage,userNameHashTagLabel])
        stack.spacing = 6
        return stack
    }()
    let separator : UIView = {
        let sep = UIView()
        sep.backgroundColor = UIColor(white: 0.8, alpha: 1)
        return sep
    }()
    func setupViews()
    {
        backgroundColor = UIColor(white: 0.9, alpha: 0.1)
        addSubview(mainStack)
        addSubview(separator)
        mainStack.anchorToView(top: topAnchor, left: leftAnchor, bottom: separator.topAnchor, right: rightAnchor, padding: .init(top: 12, left: 12, bottom: 12, right: 12), size: .init(width: 0, height: 40))
        profileHashTagImage.anchorToView(size:.init(width: 40, height: 40))
        separator.anchorToView(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, padding: .init(top: 0, left: 32, bottom: 0, right: 0), size: .init(width: 0, height: 1))
        
    }
}

