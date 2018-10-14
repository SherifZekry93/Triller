//
//  HomeFeedCell.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/13/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
class HomeFeedCell: UICollectionViewCell {
    
    let profileImage:UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "profile-imag")
        return image
    }()
    
    let userNameTimeLabel:UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Sherif Zekry", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 18)])
        attributedText.append(NSAttributedString(string: "\n6 days ago", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15),NSAttributedStringKey.foregroundColor:UIColor.gray]))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        label.numberOfLines = -1
        label.attributedText = attributedText
        return label
    }()
    let menuButton:UIButton = {
        let button = UIButton()
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    let captionLabel:UILabel = {
        let view = UILabel()
        return view
    }()
    let playButton:UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        button.tintColor = .orange
        return button
    }()
    let recordSlider:UISlider = {
        let slider = UISlider()
        slider.thumbTintColor = .red
        return slider
    }()
    let timeLabel:UILabel = {
        let label = UILabel()
        label.text = "00:00"
        return label
    }()
    let likeButton:UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "love"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    let commentButton:UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    lazy var topStackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImage,userNameTimeLabel])
        stack.distribution = .fill//Equally
        stack.spacing = 12
        return stack
    }()
    lazy var controlsStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [likeButton,commentButton])
        stack.spacing = 40
        return stack
    }()
    let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let postTitle:UITextView = {
        let title = UITextView()
        title.text = "Hello How are \n you are you alright"
        return title
    }()
    lazy var bottomStack:UIStackView = {
       let stack = UIStackView(arrangedSubviews: [playButton,recordSlider,timeLabel])
        stack.spacing = 4
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
        addSubview(containerView)
        containerView.addSubview(bottomStack)
        containerView.addSubview(controlsStack)
        containerView.addSubview(menuButton)
        backgroundColor = .gray
        containerView.anchorToView(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8))
        containerView.addSubview(topStackView)
        topStackView.anchorToView(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, padding: .init(top: 12, left: 12, bottom: 0, right: 62), size: .init(width: 0, height: 50))
        profileImage.anchorToView(size: .init(width: 50, height: 0))
        menuButton.anchorToView(top: userNameTimeLabel.topAnchor, left: nil, bottom: nil, right:containerView.rightAnchor, padding: .init(top: -12, left: 12, bottom: 0, right: 12), size: .init(width: 50, height: 50))
        containerView.addSubview(postTitle)
        postTitle.anchorToView(top: topStackView.bottomAnchor, left: topStackView.leftAnchor, bottom: bottomStack.topAnchor, right: menuButton.rightAnchor,padding: .init(top: 0, left: 0, bottom: 12, right: 0))
      
        bottomStack.anchorToView(top: postTitle.bottomAnchor, left: postTitle.leftAnchor, bottom: controlsStack.topAnchor, right: postTitle.rightAnchor, padding: .init(top: 12, left: 0, bottom:12, right: 0), size: .init(width: 0, height: 40))
        controlsStack.anchorToView(top: bottomStack.bottomAnchor, left: bottomStack.leftAnchor, bottom: containerView.bottomAnchor, right:nil, padding: .init(top: 12, left: 20, bottom: 12, right: 0), size: .init(width: 120, height: 40))
        likeButton.anchorToView( size: .init(width: 40, height: 40))
        commentButton.anchorToView(size: .init(width: 40, height: 40))
    }
}
