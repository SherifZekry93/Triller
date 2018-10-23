//
//  MainProfileCell.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/14/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import Firebase
protocol ProfileViewStartScrolling {
    func didScroll(imageView:UIImageView)
}
class MainProfileController: UICollectionViewController,UICollectionViewDelegateFlowLayout{
    let cellID = "cellID"
    let profileHeaderID = "profileHeaderID"
    var headerImage:UIImageView?
    var posts = [AudioPost]()
    var uid:String?
    var user:User?{
        didSet
        {
            guard let user = user else {return}
            FirebaseService.shared.fetchPostusinguid(user: user, completitionHandler: { (allAudios) in
            self.posts = allAudios
            self.collectionView.reloadData()
            })
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationController()
        if user == nil
        {
            fetchUserUsinguid()
        }
    }
    func fetchUserUsinguid()
    {
         let uid = self.uid ?? Auth.auth().currentUser?.uid ?? "17gYsB7Sc2QUqJ41XDbqtKvoW1B2"
         FirebaseService.shared.fetchUserByuid(uid:uid, completitionHandler: { (user) in
                    self.user = user
            })
    }
    
    func setupNavigationController()
    {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .white
    }
    
    func setupCollectionView()
    {
        collectionView.backgroundColor = .lightGray
        collectionView.register(ProfilePostCell.self, forCellWithReuseIdentifier: cellID);
        collectionView.register(ProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: profileHeaderID)
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
    }
    var animatedHeaderImageView:UIView?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 305)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: profileHeaderID, for: indexPath) as! ProfileHeaderCell
        header.backgroundColor = UIColor(red: 254/255, green: 254/255, blue: 254/255, alpha: 1)
        
        header.user = user
        //headerImage =  header.profilePicture
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 0, bottom: 10, right: 0)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ProfilePostCell
        cell.post = posts[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 220)
        let dummyCell = ProfilePostCell(frame: frame)
        dummyCell.post = posts[indexPath.item]
        dummyCell.layoutIfNeeded()
        let estimatedsize = dummyCell.systemLayoutSizeFitting(CGSize(width: frame.width, height: 1000))
        let height = max(150, estimatedsize.height)
        return CGSize(width: view.frame.width, height: height)
    }
}
