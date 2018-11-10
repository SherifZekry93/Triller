//
//  Listener.swift
//  Triller
//
//  Created by Sherif  Wagih on 11/9/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
class ListenerCell: UICollectionViewCell
{
    let profileImage:UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .red
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.image = #imageLiteral(resourceName: "profile-imag")
        return image
    }()
    
    let userNameLabel:UILabel = {
        let label = UILabel()
        label.text = "Sherif Zekry"
        return label
    }()
    
    lazy var followUnfollowImage:UIButton = {
        let button = UIButton()
        button.setTitle("user name", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setImage(#imageLiteral(resourceName: "button_add"), for: .normal)
        button.addTarget(self, action: #selector(followThisUser), for: .touchUpInside)
        return button
    }()
    
    lazy var controlsContainerStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImage,userNameLabel,followUnfollowImage])
        stack.alignment = .center
        stack.spacing = 6
        return stack
    }()
    
    var user:User?{
        didSet{
            setupFollowButton()
            guard let user = user else {return}
            //to be changed to user full name
            userNameLabel.text = user.user_name
            guard let imagePath = URL(string: user.picture_path) else {return}
            profileImage.sd_setImage(with: imagePath, completed: nil)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupViews()
    }
    
    func setupViews()
    {
        addSubview(controlsContainerStack)
        controlsContainerStack.anchorToView(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 12, left: 12, bottom: 12, right: 12))
        profileImage.anchorToView(size:.init(width: 40, height: 40))
        followUnfollowImage.anchorToView(size:.init(width: 35, height: 35))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
                    self.followUnfollowImage.setImage(#imageLiteral(resourceName: "button_tick"), for:.normal)
                    self.followUnfollowImage.isHidden = false
                }
            }) { (err) in
                
            }
        }
    }
    @objc func followThisUser()
    {
        guard let currentID = Auth.auth().currentUser?.uid else {return}
        guard let userID = user?.uid else {return}
        self.followUnfollowImage.isUserInteractionEnabled = false
        if self.followUnfollowImage.imageView?.image == #imageLiteral(resourceName: "button_add")
        {
            //follow the user
            self.followUnfollowImage.setImage(#imageLiteral(resourceName: "button_tick"), for: .normal)
            //change the image
            let creationDate = Date().timeIntervalSince1970
            let followingNodeValues = ["create_date": creationDate ,"following_uid":userID] as [String : Any];
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
                    })
                }
            }
        }
        else
        {
            self.followUnfollowImage.setImage(#imageLiteral(resourceName: "button_add"), for: .normal)//.imageView?.image = #imageLiteral(resourceName: "button_add")
            let ref =  Database.database().reference().child("following").child(currentID)
            let query = ref.queryOrdered(byChild: "following_uid").queryEqual(toValue: userID)
            query.observe(.value, with: { (snap) in
                print(snap)
                guard let childNode = snap.value as? [String:Any] else {return}
                childNode.forEach({ (key,value) in
                    if self.followUnfollowImage.imageView?.image == #imageLiteral(resourceName: "button_add"){

                        ref.child(key).removeValue()
                    }
                    let followerRef = Database.database().reference().child("followers").child(userID)
                    let queryFollowers = followerRef.queryOrdered(byChild: "follower_uid").queryEqual(toValue: currentID)
                    queryFollowers.observe(.value, with: { (snap) in
                        let childs = snap.value as? [String:Any]
                        childs?.forEach({ (key,value) in
                            if self.followUnfollowImage.imageView?.image == #imageLiteral(resourceName: "button_add"){
                                followerRef.child(key).removeValue()
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
}
