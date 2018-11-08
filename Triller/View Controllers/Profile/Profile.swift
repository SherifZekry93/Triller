//
//  MainProfileCell.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/14/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import Firebase
import AVKit
import ProgressHUD
protocol ProfileViewStartScrolling
{
    func didScroll(imageView:UIImageView)
}
class MainProfileController: UICollectionViewController,UICollectionViewDelegateFlowLayout,tappedProfileOrNameLabelOrCommentsDelegate{
    func viewProfile(gesture: UITapGestureRecognizer) {
        
    }
    
    func viewComments(gesture: UITapGestureRecognizer) {
        self.tabBarController?.tabBar.isHidden = true
        //self.tabBarController?.tabBar.transform = translate
        let layout = UICollectionViewFlowLayout()
        let commentsController = CommentsController(collectionViewLayout:layout)
        let indexPath = getIndex(gesture: gesture)
        let post = posts[indexPath.item]
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
    }
    func getIndex(gesture:UIGestureRecognizer) -> IndexPath
    {
        let location = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: location) else {return IndexPath()}
        return indexPath
    }
    var player:AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
   
    

    let cellID = "cellID"
    let profileHeaderID = "profileHeaderID"
    var headerImage:UIImageView?
    var posts = [AudioPost]()
    var uid:String?
    var user:User?{
        didSet
        {
            posts.removeAll()
            guard let user = user else {return}
            FirebaseService.fetchPostusinguid(user: user, completitionHandler: { (allAudios) in
                self.posts = allAudios
                self.collectionView.reloadData()
            })
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupCollectionView()
        setupCustomNavigationBar()
        if user == nil
        {
            fetchUserUsinguid()
        }
    }
    
    func fetchUserUsinguid()
    {
        let uid = self.uid ?? Auth.auth().currentUser?.uid ?? ""
        FirebaseService.fetchUserByuid(uid:uid, completitionHandler: { (user) in
            self.user = user
        })
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
    }
    func setupCustomNavigationBar()
    {
        guard let height = UIApplication.shared.keyWindow?.safeAreaInsets.top else {return}
        let navView = UIView()
        navView.backgroundColor = .green
        self.view.addSubview(navView)
        navView.anchorToView(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 50 + height))
    }
    
    func setupNavigationController()
    {
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func setupCollectionView()
    {
        collectionView.backgroundColor = .lightGray
        collectionView.register(ProfilePostCell.self, forCellWithReuseIdentifier: cellID);
        collectionView.register(ProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: profileHeaderID)
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
    }
    var animatedHeaderImageView:UIView?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 270)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: profileHeaderID, for: indexPath) as! ProfileHeaderCell
        header.backgroundColor = UIColor(red: 254/255, green: 254/255, blue: 254/255, alpha: 1)
        header.user = user
        header.posts = posts
        headerImage = header.profilePicture
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 0, bottom: 10, right: 0)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ProfilePostCell
        cell.delegate = self
        let post = posts[indexPath.item]
        if let user = user
        {
            post.user = user
        }
        cell.post = post
        cell.homeController = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 220)
        let dummyCell = ProfilePostCell(frame: frame)
        dummyCell.post = posts[indexPath.item]
        dummyCell.layoutIfNeeded()
        let estimatedsize = dummyCell.systemLayoutSizeFitting(CGSize(width: frame.width, height: 1000))
        let height = estimatedsize.height//max(150, estimatedsize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
}
