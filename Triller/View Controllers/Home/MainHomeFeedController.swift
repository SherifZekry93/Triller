//
//  HomeFeedCell.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/14/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer
import Firebase
class MainHomeFeedController: UICollectionViewController,UICollectionViewDelegateFlowLayout
{
    let cellID = "cellID"
    var audioPosts:[AudioPost]?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    var uid:String?{
        didSet{
            guard let uid = uid else {return}
            fetchFollowing(uid: uid)
        }
    }
    var hashTag:HashTag?{
        didSet{
            guard let hashTag = hashTag else {return}
            fetchPostsForHashtag(hashTag: hashTag)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupAudioSession()
        if hashTag == nil
        {
            guard let currentUserID = Auth.auth().currentUser?.uid else {return}
            fetchFollowing(uid: currentUserID)
        }
    }
    func fetchFollowing(uid:String)
    {
        setupNavigationController()
        FirebaseService.shared.fetchFollowingPosts(uid: uid) { (allAudioPosts) in
            self.audioPosts = allAudioPosts
        }
    }
    func fetchPostsForHashtag(hashTag:HashTag)
    {
        FirebaseService.shared.getPostsByHashtag(hashtag: hashTag) { (allPosts) in
            self.audioPosts = allPosts
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return audioPosts?.count  ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 220)
        let dummyCell = HomeFeedCell(frame: frame)
        dummyCell.post = audioPosts?[indexPath.item]
        dummyCell.layoutIfNeeded()
        let estimatedsize = dummyCell.systemLayoutSizeFitting(CGSize(width: frame.width, height: 1000))
        let height = max(170, estimatedsize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for:indexPath) as! HomeFeedCell
        let post = audioPosts?[indexPath.item]
        cell.post = post
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    func setupCollectionView()
    {
        collectionView.register(HomeFeedCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.backgroundColor = .lightGray
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        
    }
    func setupNavigationController()
    {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        let leftBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "logo-empty").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        leftBarButton.imageInsets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 0)
        navigationItem.leftBarButtonItem  = leftBarButton
        let rightbarImage = #imageLiteral(resourceName: "nav_more_icon").withRenderingMode(.alwaysTemplate)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:rightbarImage, style: .plain, target: self, action:#selector(handleShowEditProfile))
        navigationItem.rightBarButtonItem?.tintColor  = .black
    }
    fileprivate func setupAudioSession()
    {
        do
        {
            try AVAudioSession.sharedInstance().setCategory(.playback,mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            playSound()
        }
        catch
        {
            print("Error setting session")
        }
    }
    var player : AVPlayer?
    func playSound()
    {
        let url:String = "https://firebasestorage.googleapis.com/v0/b/trill-8aa7b.appspot.com/o/d6gdQK4xZPZkj6i8UKvF6ON3IVA3%2FAudioPosts%2FTrill_Audio_rWUxfQZDUE3VNttjOWeKinVIJpw1jml_1525701682431.mp3?alt=media&token=2376eb8b-2969-4c22-99b3-487611b8d09c"
        guard let actualURL = URL(string: url) else {return}
        let item = AVPlayerItem(url: actualURL)
        player = AVPlayer(playerItem: item)
        player?.play()
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let layout = UICollectionViewFlowLayout()
        let profileController = MainProfileController(collectionViewLayout:layout)
        profileController.user = audioPosts?[indexPath.item].user;
        navigationController?.pushViewController(profileController, animated: true)
        
    }
    
    @objc func handleShowEditProfile()
    {
        let alert = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
        
        alert.view.frame = CGRect(x: alert.view.frame.origin.x, y: self.view.frame.height / 2, width: alert.view.frame.width, height: alert.view.frame.height);

        let editAction = UIAlertAction(title: "Edit Profile", style: .default) { (action) in
            let editProfileController = EditProfileViewController()
            self.navigationController?.pushViewController(editProfileController, animated: true)
        }
        let signOutAction = UIAlertAction(title: "Signout", style: .default) { (action) in
            let signOutAlert = UIAlertController(title: nil, message: "Are you sure you want to Logout?", preferredStyle: UIAlertController.Style.alert)

            signOutAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (Action) in
                do
                {
                    try Auth.auth().signOut()
                    let loginNav = UINavigationController(rootViewController:  LoginController())
                    self.present(loginNav, animated: true, completion: nil)
                }
                catch
                {
                    
                }
            }))
            signOutAlert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { (alert) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(signOutAlert, animated: true, completion: nil)
        }
        
        alert.addAction(editAction)
        alert.addAction(signOutAction)
        present(alert, animated: true){
             alert.view.superview?.subviews.first?.isUserInteractionEnabled = true
            alert.view.superview?.subviews.first?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.actionSheetBackgroundTapped)))
            
        }
        
    }
    @objc func actionSheetBackgroundTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}
