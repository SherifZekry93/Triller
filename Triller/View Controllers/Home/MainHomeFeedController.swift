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
import ProgressHUD
class MainHomeFeedController: UICollectionViewController,UICollectionViewDelegateFlowLayout,tappedProfileOrNameLabelOrCommentsDelegateOrPlay
{
    func viewProfile(gesture:UITapGestureRecognizer)
    {
        let layout = UICollectionViewFlowLayout()
        let profileController = MainProfileController(collectionViewLayout:layout)
        let indexPath = getIndex(gesture: gesture)
        profileController.user = audioPosts[indexPath.item].user;
        navigationController?.pushViewController(profileController, animated: true)
    }
    
    func viewComments(gesture:UITapGestureRecognizer)
    {
        self.tabBarController?.tabBar.isHidden = true
        //self.tabBarController?.tabBar.transform = translate
        let layout = UICollectionViewFlowLayout()
        let commentsController = CommentsController(collectionViewLayout:layout)
        let indexPath = getIndex(gesture: gesture)
        let post = audioPosts[indexPath.item]// else {return}
        commentsController.post = post//audioPosts[indexPath.item]
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    func getIndex(gesture:UIGestureRecognizer) -> IndexPath
    {
    let location = gesture.location(in: collectionView)
    guard let indexPath = collectionView.indexPathForItem(at: location) else {return IndexPath()}
        return indexPath
    }
    
    var player:AVAudioPlayer = {
        let avPlayer = AVAudioPlayer()
        return avPlayer
    }()
    
    func playEpisode(url: URL) {
        CustomAvPlayer.shared.loadSoundUsingSoundURL(url: url) { (data) in
            if let data = data
            {
                do
                {
                    self.player =  try AVAudioPlayer(data: data, fileTypeHint: "m4a")
                    self.player.prepareToPlay()
                    self.player.play()
                }
                catch
                {
                    ProgressHUD.showError("Failed to Play sound")
                }
            }
            else
            {
                ProgressHUD.showError("Failed to load sound")
            }
        }
    }
    
    let cellID = "cellID"
    var audioPosts:[AudioPost] = [AudioPost]()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.items?.forEach({ (item) in
            item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        if hashTag == nil
        {
            guard let currentUserID = Auth.auth().currentUser?.uid else {return}
            fetchFollowing(uid: currentUserID)
        }
        else
        {
            
        }
        let name = NSNotification.Name(rawValue: "FeedUpdated")
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: name, object: nil)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = false
        if hashTag != nil
        {
            var counter = 0
            self.tabBarController?.tabBar.items?.forEach({ (item) in
                counter += 1
                if counter != 3
                {
                    item.imageInsets = UIEdgeInsets(top: 130, left: 0, bottom: 0, right: 0)
                }
            })
            
        }
    }
    
    func fetchFollowing(uid:String)
    {
        setupNavigationController()
        FirebaseService.fetchFollowingPosts(uid: uid) { (allAudioPosts) in
            self.audioPosts = allAudioPosts.sorted(by: { (post1, post2) -> Bool in
                return post1.creationDate.compare(post2.creationDate) == .orderedDescending
            })
            self.collectionView.reloadData()
            if self.collectionView.refreshControl?.isRefreshing ?? false
            {
                self.collectionView?.refreshControl?.endRefreshing()
            }
        }
    }
    
    func fetchPostsForHashtag(hashTag:HashTag)
    {
        FirebaseService.getPostsByHashtag(hashtag: hashTag) { (allPosts) in
            self.audioPosts = allPosts
            self.collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return audioPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 220)
        let dummyCell = HomeFeedCell(frame: frame)
        print(audioPosts[indexPath.item].audioNote)
        dummyCell.post = audioPosts[indexPath.item]
        dummyCell.layoutIfNeeded()
        let estimatedsize = dummyCell.systemLayoutSizeFitting(CGSize(width: frame.width, height: 1000))
        let height = estimatedsize.height
        return CGSize(width: view.frame.width, height: height)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for:indexPath) as! HomeFeedCell
        let post = audioPosts[indexPath.item]
        cell.post = post
        cell.delegate = self
        cell.homeFeedController = self
        if let hashTag = hashTag
        {
            cell.hashTagName = hashTag.hashTagName
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    func setupCollectionView()
    {
        collectionView.register(HomeFeedCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.backgroundColor = .lightGray
        //collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
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
        }
        catch
        {
            print("Error setting session")
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
        alert.popoverPresentationController?.sourceView = self.view

        present(alert, animated: true){
            alert.view.superview?.subviews.first?.isUserInteractionEnabled = true
            alert.view.superview?.subviews.first?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.actionSheetBackgroundTapped)))
        }
        
    }
    @objc func actionSheetBackgroundTapped() {
        dismiss(animated: true, completion: nil)
    }
    @objc func handleUpdateFeed()
    {
        
        handleRefresh()
    }
    @objc func handleRefresh()
    {
        if hashTag == nil
        {
            guard let currentUserID = Auth.auth().currentUser?.uid else {return}
            fetchFollowing(uid: currentUserID)
        }
        else
        {
            guard let hash = hashTag else {return}
            fetchPostsForHashtag(hashTag: hash)
        }
    }
}
