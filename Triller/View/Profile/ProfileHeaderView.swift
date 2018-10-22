//
//  ProfileHeaderCell.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/14/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import Kingfisher
class ProfileHeaderCell: BaseCell{
    var user : User?{
        didSet
        {
            guard let user = user else {return}
            guard let picURL = URL(string:user.picture_path) else {return}
            profilePicture.kf.setImage(with: picURL, placeholder: UIImage(named: "profile-imag"))
            profilePicture.contentMode = .scaleAspectFill
            //set full name label and status
            let attributedText = NSMutableAttributedString(string: "\(user.full_name)\n", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20)])
            attributedText.append(NSAttributedString(string: "\(user.status == "" ? "No Status": user.status)", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.gray]))
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 3
            attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
            userNameStatusLabel.attributedText = attributedText
            userNameStatusLabel.textAlignment = .center
            //set trillsattributedText
            let trillsattributedText = NSMutableAttributedString(string: "\(user.posts.count)\n", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 21),NSAttributedString.Key.foregroundColor:UIColor.darkGray])
            trillsattributedText.append(NSAttributedString(string: "Trills", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.gray]))
            let trillsparagraphStyle = NSMutableParagraphStyle()
            trillsparagraphStyle.lineSpacing = 4
            trillsattributedText.addAttribute(.paragraphStyle, value: trillsparagraphStyle, range: NSMakeRange(0, trillsattributedText.length))
            trillsLabel.attributedText = trillsattributedText
            trillsLabel.textAlignment = .center
        }
    }
    let profilePicture:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "profile-imag")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 65
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor(white: 0.95, alpha: 1).cgColor
        iv.layer.borderWidth = 3
        return iv
    }()
    let userNameStatusLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = -1
        let attributedText = NSMutableAttributedString(string: "Sherif Zekry\n", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20)])
        attributedText.append(NSAttributedString(string: "No Status", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.gray]))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        label.attributedText = attributedText
        label.textAlignment = .center
        return label
    }()
    let trillsLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = -1
        label.textAlignment = .center
        let trillsattributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 21),NSAttributedString.Key.foregroundColor:UIColor.darkGray])
        trillsattributedText.append(NSAttributedString(string: "Trills", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.gray]))
        let trillsparagraphStyle = NSMutableParagraphStyle()
        trillsparagraphStyle.lineSpacing = 4
        trillsattributedText.addAttribute(.paragraphStyle, value: trillsparagraphStyle, range: NSMakeRange(0, trillsattributedText.length))
        label.attributedText = trillsattributedText
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
