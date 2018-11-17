//
//  ProfileHeaderCell.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/14/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

protocol ViewUserDetails
{
    func viewListeners()
    func viewSpeakers()
}
import UIKit
import SDWebImage
import Firebase
class ProfileHeaderCell: BaseCell{
    var viewUserDetailsdelegate:ViewUserDetails?
    var homeController:MainProfileController?
    var posts:[AudioPost]?{
        didSet{
            guard let posts = posts else {return}
            let trillsattributedText = NSMutableAttributedString(string: "\(posts.count)\n", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 21),NSAttributedString.Key.foregroundColor:UIColor.darkGray])
            trillsattributedText.append(NSAttributedString(string: "Trills", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.gray]))
            let trillsparagraphStyle = NSMutableParagraphStyle()
            trillsparagraphStyle.lineSpacing = 4
            trillsattributedText.addAttribute(.paragraphStyle, value: trillsparagraphStyle, range: NSMakeRange(0, trillsattributedText.length))
            trillsLabel.attributedText = trillsattributedText
            trillsLabel.textAlignment = .center
        }
    }
    
    var user : User?{
        didSet
        {
            setupFollowButton()
            setupListenerButton()
            setupSpeakerButton()
            guard let user = user else {return}
            if let picURL = URL(string:user.picture_path)
            {
                profilePicture.sd_setImage(with: picURL) { (_, err, _, _) in
                    if err != nil
                    {
                        self.profilePicture.image =   #imageLiteral(resourceName: "profile-imag")
                    }
                }
               // profilePicture.sd_setImage(with: picURL, completed: nil)
            }
            else
            {
                profilePicture.image =   #imageLiteral(resourceName: "profile-imag")
            }
            profilePicture.contentMode = .scaleAspectFill
            //set full name label and status
            let attributedText = NSMutableAttributedString(string: "\(user.full_name == "" ? "Trill User" : user.full_name)\n", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20)])
            attributedText.append(NSAttributedString(string: "\(user.status == "" ? "No Status": user.status)", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.gray]))
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 3
            attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
            userNameStatusLabel.attributedText = attributedText
            userNameStatusLabel.textAlignment = .center
        }
    }
    
    let profilePicture:UIImageView = {
        let iv = UIImageView()
        iv.sd_setIndicatorStyle(.gray)
        iv.sd_setShowActivityIndicatorView(true)
       // iv.image = #imageLiteral(resourceName: "profile-imag")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 65
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor(white: 0.95, alpha: 1).cgColor
        iv.layer.borderWidth = 3
        return iv
    }()
    
    lazy var followUnfollowImage:UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "button_add")
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(followThisUser)))
        image.isHidden = true
        return image
    }()
    
    let userNameStatusLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = -1
        let attributedText = NSMutableAttributedString(string: "Trill User\n", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20)])
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
    
    lazy var speakerLabel:UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 21),NSAttributedString.Key.foregroundColor:UIColor.darkGray])
        attributedText.append(NSAttributedString(string: "Speaker", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.gray]))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        label.attributedText = attributedText
        label.numberOfLines = -1
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleViewSpeakers)))
        return label
    }()
    
    lazy var listenersLabel:UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleViewListeners)))
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 21),NSAttributedString.Key.foregroundColor:UIColor.darkGray])
        attributedText.append(NSAttributedString(string: "Listeners", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.gray]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        label.numberOfLines = -1
        label.attributedText = attributedText
        label.textAlignment = .center
        return label
    }()
    
    lazy var labelsStackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [trillsLabel,speakerLabel,listenersLabel])
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var searchWithNoActive:UIImageView = {
        let search = UIImageView(image: #imageLiteral(resourceName: "with-notactive").withRenderingMode(.alwaysTemplate))
        search.tintColor = .orange
        search.contentMode = .scaleAspectFit
        search.isUserInteractionEnabled = true
        //search.tag = 0
        search.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reloadDataNormally)))
        return search
    }()
    
    lazy var searchWithActive:UIImageView = {
        let search = UIImageView(image: #imageLiteral(resourceName: "without-notactive").withRenderingMode(.alwaysTemplate))
        search.tintColor = .orange
        search.contentMode = .scaleAspectFit
        //search.tag = 1
        search.isUserInteractionEnabled = true
        search.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reloadDataAbNormally)))
        return search
    }()
    
    lazy var searchStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [firstBottomStackSeparator, searchWithNoActive,secondBottomStackSeparator,searchWithActive,lastBottomStackSeparator,horizontalBottomStackSeparator])
        return stack
    }()
    
    
    lazy var playButton:UIButton = {
        let button = UIButton()
        let image = UIImage()
        button.setImage(#imageLiteral(resourceName: "ic_action_play"), for: .normal)
        button.setTitle("Play All", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -65, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(playAllSounds), for: .touchUpInside)
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
        profilePicture.anchorToView(top: topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 130, height: 130), centerH: true)
        userNameStatusLabel.anchorToView(top: profilePicture.bottomAnchor, leading: leadingAnchor, bottom: labelsStackView.topAnchor, trailing: trailingAnchor)
        labelsStackView.anchorToView(top: userNameStatusLabel.bottomAnchor, leading: leadingAnchor, bottom: labelsBottomStackSeparator.topAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 10, right: 0))
        labelsBottomStackSeparator.anchorToView(top: labelsStackView.bottomAnchor, leading: leadingAnchor, bottom: bottomStack.topAnchor, trailing: trailingAnchor,padding: .init(top: 10, left: 0, bottom: 0, right: 0),size:.init(width: 0, height: 1))
        bottomStack.anchorToView(top: labelsBottomStackSeparator.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 40))
        searchStack.anchorToView(size:.init(width: 141, height: 40))
        horizontalBottomStackSeparator.anchorToView(size:.init(width: 1, height: 40))
        searchWithNoActive.anchorToView(size:.init(width: 40, height: 40))
        searchWithActive.anchorToView(size:.init(width: 40, height: 40))
        firstBottomStackSeparator.anchorToView(size:.init(width: 15, height: 40))
        secondBottomStackSeparator.anchorToView(size:.init(width: 30, height: 40))
        lastBottomStackSeparator.anchorToView(size:.init(width: 15, height: 40))
        playButton.anchorToView( size: .init(width: 0, height: 30))
        addSubview(followUnfollowImage)
        followUnfollowImage.anchorToView(top: profilePicture.bottomAnchor , leading: nil, bottom: nil, trailing: profilePicture.trailingAnchor, padding: .init(top:-35, left: 0, bottom: -35, right: 0), size: .init(width: 40, height: 40))
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        //parentCollection?.didScroll(imageView: profilePicture)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func followThisUser()
    {
        guard let currentID = Auth.auth().currentUser?.uid else {return}
        guard let userID = user?.uid else {return}
        self.followUnfollowImage.isUserInteractionEnabled = false
        if self.followUnfollowImage.image == #imageLiteral(resourceName: "button_add")
        {
            //follow the user
            self.followUnfollowImage.image = #imageLiteral(resourceName: "button_tick")
            //change the image
            let creationDate = Date().timeIntervalSince1970
            let followingNodeValues = ["create_date": creationDate ,"following_uid":userID] as [String : Any]
             Database.database().reference().child("following").child(currentID).childByAutoId().updateChildValues(followingNodeValues) { (err, ref) in
                if err != nil
                {
                    self.followUnfollowImage.isUserInteractionEnabled = true
                    print("err following the user",err!)
                    return
                }
                else
                {
                    
                    let followersNodeValues = ["create_date":creationDate,"follower_uid":currentID] as [String:Any]
                    Database.database().reference().child("followers").child(userID).childByAutoId().updateChildValues(followersNodeValues, withCompletionBlock: { (err, ref) in
                        if err != nil
                        {
                            self.followUnfollowImage.isUserInteractionEnabled = true

                            print("error following the user",err!)
                            return
                        }
                        self.followUnfollowImage.isUserInteractionEnabled = true
                        //self.updateNotification(type: "3")
                    })
                }
            }
        }
        else
        {
            self.followUnfollowImage.image = #imageLiteral(resourceName: "button_add")
            let ref =  Database.database().reference().child("following").child(currentID)
            let query = ref.queryOrdered(byChild: "following_uid").queryEqual(toValue: userID)
            query.observe(.value, with: { (snap) in
                guard let childNode = snap.value as? [String:Any] else {return}
                childNode.forEach({ (key,value) in
                    if self.followUnfollowImage.image == #imageLiteral(resourceName: "button_add"){
                        ref.child(key).removeValue()
                    }
                    let followerRef = Database.database().reference().child("followers").child(userID)
                    let queryFollowers = followerRef.queryOrdered(byChild: "follower_uid").queryEqual(toValue: currentID)
                    queryFollowers.observe(.value, with: { (snap) in
                        let childs = snap.value as? [String:Any]
                        childs?.forEach({ (key,value) in
                            if self.followUnfollowImage.image == #imageLiteral(resourceName: "button_add"){
                                followerRef.child(key).removeValue()
                                self.removeNotification()
                            }
                        })
                        self.followUnfollowImage.isUserInteractionEnabled = true
                    }, withCancel: { (err) in
                        print("err following the user")
                        self.followUnfollowImage.isUserInteractionEnabled = true
                    })
                })
            }) { (err) in
                print("err following the user")
                self.followUnfollowImage.isUserInteractionEnabled = true
                return
            }
        }
    }
    func setupFollowButton()
    {
        guard let currentID = Auth.auth().currentUser?.uid else {return}
        guard let user = user else {return}
        if user.uid == currentID
        {
            self.followUnfollowImage.isHidden = true
        }
        else
        {
           let ref =  Database.database().reference().child("following").child(currentID)
            let query = ref.queryOrdered(byChild: "following_uid").queryEqual(toValue: user.uid)
            query.observe(.value, with: { (snap) in
                if snap.value is NSNull
                {
                    self.followUnfollowImage.isHidden = false
                }
                else
                {
                    self.followUnfollowImage.image = #imageLiteral(resourceName: "button_tick")
                    self.followUnfollowImage.isHidden = false
                }
            }) { (err) in
                
            }
        }
    }
    
    func setupListenerButton()
    {
       // DispatchQueue.main.async {
        guard let currentID = self.user?.uid else {return}
        let ref = Database.database().reference().child("followers").child(currentID)
        ref.observe(.value, with: { (snapshot: DataSnapshot) in
            let attributedText = NSMutableAttributedString(string: "\(snapshot.childrenCount)\n", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 21),NSAttributedString.Key.foregroundColor:UIColor.darkGray])
            attributedText.append(NSAttributedString(string: "Listeners", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.gray]))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
            self.listenersLabel.attributedText = attributedText
            self.listenersLabel.textAlignment = .center
        })
        
     //   }
    }
    func setupSpeakerButton()
    {
        //DispatchQueue.main.async {
            guard let currentID = self.user?.uid else {return}
            let ref = Database.database().reference().child("following").child(currentID)
            ref.observe(.value, with: { (snap) in
                let attributedText = NSMutableAttributedString(string: "\(snap.childrenCount)\n", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 21),NSAttributedString.Key.foregroundColor:UIColor.darkGray])
                attributedText.append(NSAttributedString(string: "Speaker", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.gray]))
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
                self.speakerLabel.attributedText = attributedText
                self.speakerLabel.textAlignment = .center
            }) { (err) in
                
            }

       // }
    }
    @objc func handleViewListeners()
    {
        viewUserDetailsdelegate?.viewListeners()
    }
    @objc func handleViewSpeakers()
    {
        viewUserDetailsdelegate?.viewSpeakers()
    }
    func updateNotification(type:String)
    {
        guard let currentID = Auth.auth().currentUser?.uid else {return}
        guard let user = user else {return}
        let values = ["creationDate" : Date().timeIntervalSince1970, "fromUser" : currentID,"hashID":"","to":user.uid,type:type] as [String : Any]
        let ref = Database.database().reference().child("notification").childByAutoId()
        ref.updateChildValues(values) { (err, ref) in
            if err != nil
            {
                print("hello")
                return
            }
            print("posted notificatoion")
        }
    }
    func removeNotification()
    {
        //let ref = Database.database().reference().child("notification").queryOrdered(byChild: "from")
       //guard let user = user else {return}
       //loadNotificationByuid(uid: user.uid, delete:true)
    }
    var notifications:[MyNotification]?
    func loadNotificationByuid(uid:String,delete:Bool)
    {
        FirebaseService.getNotificationByuid(uid: uid) { (allNotifications) in
            if let notifications = allNotifications
            {
                self.notifications = notifications
                if delete
                {
                    self.notifications?.forEach({ (noti) in
                        if noti.to == self.user?.uid && noti.type == "3" && noti.fromUser == Auth.auth().currentUser?.uid
                        {
                            Database.database().reference().child("notification").child(noti.notificationID).removeValue()
                        }
                    })
                }
            }
        }
    }
    @objc func reloadDataNormally()
    {
        self.homeController?.isComment = false
        self.homeController?.collectionView.reloadData()
    }
    @objc func reloadDataAbNormally()
    {
        self.homeController?.isComment = true
        self.homeController?.collectionView.reloadData()
    }
    @objc func playAllSounds()
    {
        if self.playButton.imageView?.image == #imageLiteral(resourceName: "ic_action_play")
        {
            playButton.setImage(#imageLiteral(resourceName: "ic_action_pause"), for: .normal)
            if self.homeController?.player.currentItem == nil
            {
                self.homeController?.counter = 0
                homeController?.playAllSounds()
            }
            else
            {
                self.homeController?.player.play()
            }
        }
        else
        {
            if self.homeController?.player.timeControlStatus != .paused
            {
                playButton.setImage(#imageLiteral(resourceName: "ic_action_play"), for: .normal)
                homeController?.player.pause()
            }
            if self.homeController?.posts.count == self.homeController?.counter
            {
                playButton.setImage(#imageLiteral(resourceName: "ic_action_play"), for: .normal)
            }
        }
    }
}
