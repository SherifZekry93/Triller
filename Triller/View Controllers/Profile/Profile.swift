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

class MainProfileController: UICollectionViewController,UICollectionViewDelegateFlowLayout,tappedProfileOrNameLabelOrCommentsDelegateOrPlay,ViewUserDetails{
    func viewListeners()
    {
        let layout = UICollectionViewFlowLayout()
        let listeners = ListenersViewController(collectionViewLayout:layout)
        listeners.user = user
        navigationController?.pushViewController(listeners, animated: true)
    }
    
    func viewSpeakers() {
        let layout = UICollectionViewFlowLayout()
        let speakers = SpeakerViewController(collectionViewLayout:layout)
        speakers.user = user
        navigationController?.pushViewController(speakers, animated: true)
    }
    
    func playSound(slider: UISlider, url: URL) {
        
    }
    
    func viewProfile(gesture: UITapGestureRecognizer) {
        
    }
    
    func viewComments(gesture: UITapGestureRecognizer) {
        self.tabBarController?.tabBar.isHidden = true
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
    var commentCellID = "commentCellID"
    let profileHeaderID = "profileHeaderID"
    var headerImage:UIImageView?
    var posts = [AudioPost]()
    var uid:String?
    var user:User?{
        didSet
        {
            posts.removeAll()
            self.navigationItem.title = user?.user_name
            guard let user = user else {return}
            FirebaseService.fetchPostusinguid(user: user, completitionHandler: { (allAudios) in
                self.posts = allAudios.sorted(by: { (post1, post2) -> Bool in
                    return post1.creationDate.compare(post2.creationDate) == .orderedDescending
                })
                self.collectionView.reloadData()
            })
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        playerObservers()
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
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        //self.tabBarController?.tabBar.isHidden = false
        //self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isTranslucent = true
    }
    func setupCustomNavigationBar()
    {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
    }
    func setupCollectionView()
    {
        collectionView.backgroundColor = .lightGray
        collectionView.register(ProfilePostCell.self, forCellWithReuseIdentifier: cellID);
        collectionView.register(ProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: profileHeaderID)
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: commentCellID)
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        //collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
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
        header.viewUserDetailsdelegate = self
        header.homeController = self
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 0, bottom: 10, right: 0)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return posts.count
    }
    var isComment:Bool = false
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if !isComment
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
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:commentCellID , for: indexPath) as! CommentCell
            cell.post = posts[indexPath.item]
            cell.firstTimePlayer = false
            cell.recordSlider.value = 0
            cell.recordSlider.isEnabled = false
            cell.recordSlider.thumbTintColor = .gray
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if !isComment
        {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 220)
        let dummyCell = ProfilePostCell(frame: frame)
        dummyCell.post = posts[indexPath.item]
        dummyCell.layoutIfNeeded()
        let estimatedsize = dummyCell.systemLayoutSizeFitting(CGSize(width: frame.width, height: 1000))
        let height = estimatedsize.height
        return CGSize(width: view.frame.width, height: height)
        }
        else
        {
            let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 260)
            let dummyCell = CommentCell(frame: frame)
            dummyCell.post = posts[indexPath.item]
            dummyCell.layoutIfNeeded()
            let estimatedsize = dummyCell.systemLayoutSizeFitting(CGSize(width: frame.width, height: 1000))
            let height = estimatedsize.height
            return CGSize(width: view.frame.width, height: height)
        }
    }
    var counter = 0
    var isFirstTime = false
    func playAllSounds()
    {
        if counter < posts.count
        {
            downloadAndPlaySound(post: posts[counter])
        }
    }
    
    func downloadAndPlaySound(post:AudioPost)
    {
        ProgressHUD.show()
        //spinnerView?.alpha = 1
        let postURL = post.audioURL
        guard let playURL = URL(string: postURL) else {return}
        CustomAvPlayer.shared.loadSoundUsingSoundURL(url: playURL) { (data) in
            if let data = data
            {
                guard var toPlayURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
                toPlayURL.appendPathComponent("sound.m4a")
                do
                {
                    try data.write(to: toPlayURL)
                    //self.firstTimePlayer = true
                }
                catch
                {
                    return
                }
                let item = AVPlayerItem(url: toPlayURL)
                self.player.replaceCurrentItem(with: item)
                self.player.play()
            }
            else
            {
                ProgressHUD.showError("Failed to load sound")
            }
        }
    }
    fileprivate func playerObservers()
    {
        let time = CMTimeMake(value: 1,timescale: 3)
        let times = [NSValue(time:time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            //[weak self] in
            ProgressHUD.dismiss()
        }
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) {(time) in
            let duration = time.toDisplayString()
            guard let fullTime =  self.player.currentItem?.duration.toDisplayString() else {return}
            if duration == fullTime
            {
                if self.counter < self.posts.count //&&
                {
                    self.counter += 1
                    self.playAllSounds()
                }
            }
        }
    }
}
