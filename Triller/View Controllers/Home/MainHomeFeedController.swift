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
class MainHomeFeedController: UICollectionViewController,UICollectionViewDelegateFlowLayout
    {
    let cellID = "cellID"
    var audioPosts = [AudioPost]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationController()
        FirebaseService.shared.fetchFollowingPosts(uid: "jVECsq43DWUdU02e9TcuuIjeloi2") { (allAudioPosts) in
            self.audioPosts = allAudioPosts
            self.collectionView.reloadData()
        }
        setupAudioSession()
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
        dummyCell.post = audioPosts[indexPath.item]
        dummyCell.layoutIfNeeded()
        let estimatedsize = dummyCell.systemLayoutSizeFitting(CGSize(width: frame.width, height: 1000))
        let height = max(170, estimatedsize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for:indexPath) as! HomeFeedCell
       let post = audioPosts[indexPath.item]
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
}
