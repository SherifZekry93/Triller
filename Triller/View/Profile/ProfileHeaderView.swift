//
//  ProfileHeaderCell.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/14/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
class ProfileHeaderCell: BaseCell{
    //var parentCollection:ProfileViewStartScrolling?
    let profilePicture:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "profile-imag")
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 65
        return iv
    }()
    let userNameStatusLabel:UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Sherif Wagih \n", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20)])
        attributedText.append(NSAttributedString(string: "happy", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.gray]))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        label.numberOfLines = -1
        label.attributedText = attributedText
        label.textAlignment = .center
        return label
    }()
    let trillsLabel:UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 21),NSAttributedString.Key.foregroundColor:UIColor.darkGray])
        attributedText.append(NSAttributedString(string: "Trills", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.gray]))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        label.attributedText = attributedText
        label.numberOfLines = -1
        label.textAlignment = .center
        return label
    }()
    let speakerLabel:UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 21),NSAttributedString.Key.foregroundColor:UIColor.darkGray])
        attributedText.append(NSAttributedString(string: "Speaker", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.gray]))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        
        label.attributedText = attributedText
        label.numberOfLines = -1
        label.textAlignment = .center
        return label
    }()
    
    let listenersLabel:UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 21),NSAttributedString.Key.foregroundColor:UIColor.darkGray])
        attributedText.append(NSAttributedString(string: "Listeners", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.gray]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        label.attributedText = attributedText
        label.numberOfLines = -1
        label.textAlignment = .center
        return label
    }()
    
    lazy var labelsStackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [trillsLabel,speakerLabel,listenersLabel])
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let searchWithNoActive:UIImageView = {
        let search = UIImageView(image: #imageLiteral(resourceName: "with-notactive"))
        search.contentMode = .scaleAspectFit
        return search
    }()
    
    let searchWithActive:UIImageView = {
        let search = UIImageView(image: #imageLiteral(resourceName: "without-notactive"))
        search.contentMode = .scaleAspectFit
        return search
    }()
    
    lazy var searchStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [firstBottomStackSeparator, searchWithActive,secondBottomStackSeparator,searchWithNoActive,lastBottomStackSeparator,horizontalBottomStackSeparator])
        return stack
    }()
    let playButton:UIButton = {
        let button = UIButton()
        let image = UIImage()
        button.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        button.setTitle("Play All", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -15)
        return button
    }()
    lazy var bottomStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [searchStack,playButton])
        stack.alignment = .center
        return stack
    }()
    let firstBottomStackSeparator:UIView = {
        let sep = UIView()
        return sep
    }()
    
    let secondBottomStackSeparator:UIView = {
        let sep = UIView()
        return sep
    }()
    
    let lastBottomStackSeparator:UIView = {
        let sep = UIView()
        return sep
    }()
    let horizontalBottomStackSeparator:UIView = {
        let sep = UIView()
        sep.backgroundColor = .lightGray
        return sep
    }()
    let labelsBottomStackSeparator:UIView = {
        let sep = UIView()
        sep.backgroundColor = .lightGray
        return sep
    }()
    override func setupViews()
    {
        addSubview(profilePicture)
        addSubview(userNameStatusLabel)
        addSubview(labelsStackView)
        addSubview(labelsBottomStackSeparator)
        addSubview(bottomStack)
        profilePicture.anchorToView(top: topAnchor, right: nil, padding: .init(top: 30, left: 0, bottom: 0, right: 0), size: .init(width: 130, height: 130), centerH: true)
         userNameStatusLabel.anchorToView(top: profilePicture.bottomAnchor, left: leftAnchor, bottom: labelsStackView.topAnchor, right: rightAnchor)
        labelsStackView.anchorToView(top: userNameStatusLabel.bottomAnchor, left: leftAnchor, bottom: labelsBottomStackSeparator.topAnchor, right: rightAnchor,padding: .init(top: 0, left: 0, bottom: 10, right: 0))
        labelsBottomStackSeparator.anchorToView(top: labelsStackView.bottomAnchor, left: leftAnchor, bottom: bottomStack.topAnchor, right: rightAnchor,padding: .init(top: 10, left: 0, bottom: 0, right: 0),size:.init(width: 0, height: 1))
         bottomStack.anchorToView(top: labelsBottomStackSeparator.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 40))
        searchStack.anchorToView(size:.init(width: 141, height: 40))
        horizontalBottomStackSeparator.anchorToView(size:.init(width: 1, height: 40))
        searchWithNoActive.anchorToView(size:.init(width: 40, height: 40))
        searchWithActive.anchorToView(size:.init(width: 40, height: 40))
        firstBottomStackSeparator.anchorToView(size:.init(width: 15, height: 40))
        secondBottomStackSeparator.anchorToView(size:.init(width: 30, height: 40))
        lastBottomStackSeparator.anchorToView(size:.init(width: 15, height: 40))
        playButton.anchorToView( size: .init(width: 0, height: 30))
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        //parentCollection?.didScroll(imageView: profilePicture)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
