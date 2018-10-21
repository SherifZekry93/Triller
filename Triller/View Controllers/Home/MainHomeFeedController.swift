//
//  HomeFeedCell.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/14/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
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
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return audioPosts.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 220)
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
    }
}
