//
//  CustomTabBarController.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/13/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
//import SwipeableTabBarController
class MainTabBarController: UICollectionViewController,UICollectionViewDelegateFlowLayout,TabBarScrollDelegate {
  
    
    var isAnimated = false
    var homeCellFeedID = "homeCellFeedID"
    var searchFeedCellID = "searchFeedCellID"
    var notificationCellID = "notificationCellID"
    var profileCellID = "profileCellID"
    let allIDS:[String] = ["homeCellFeedID","searchFeedCellID","notificationCellID","profileCellID"]
    func tabBarScrollTo(index: Int)
    {
        if index >= 3
        {
            let indexPath = IndexPath(item: index - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: isAnimated)
        }
        else if index < 2
        {
            let indexPath = IndexPath(item: index , section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: isAnimated)
        }
        isAnimated = false
    }
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        let x = targetContentOffset.pointee.x
        var currentpage = x / view.frame.width
        let index = IndexPath(item: Int(currentpage), section: 0)
        if index.item == 2 || index.item == 3
        {
            currentpage += 1
        }
        let indexPath = IndexPath(item: Int(currentpage),section:0)
        tabBarView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        isAnimated = true
        self.tabBarView.collectionView(self.tabBarView.collectionView, didSelectItemAt: indexPath)
    }
    let tabCell = "tabCellID"
    lazy var tabBarView:TabBarView = {
        let tabbar = TabBarView()
        tabbar.delegate = self
        return tabbar
    }()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //        if false == false
        //        {
        //            let loginView = UIViewController()
        //            loginView.view.backgroundColor = .red
        //            self.present(loginView, animated: true, completion: nil)
        //        }
        setupCollectionView()
        setupTabBar()
        setupNavigationController()
        
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let  height = UIApplication.shared.statusBarFrame.height
        return UIEdgeInsets(top: height , left: 0, bottom: 0, right: 0)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    func setupNavigationController()
    {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.isTranslucent = true
    }
    func setupCollectionView()
    {
        collectionView?.backgroundColor = .blue//red
        collectionView?.isPagingEnabled = true
        let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: tabCell)
        collectionView?.register(MainHomeFeedCell.self, forCellWithReuseIdentifier: homeCellFeedID)
        collectionView?.register(MainSearchFeedCell.self, forCellWithReuseIdentifier: searchFeedCellID)
        collectionView?.register(MainNotificationCell.self, forCellWithReuseIdentifier: notificationCellID)
        collectionView?.register(MainProfileCell.self, forCellWithReuseIdentifier: profileCellID)
        collectionView?.bounces = false
    }
    
    func setupTabBar()
    {
        view.addSubview(tabBarView)
        tabBarView.backgroundColor = .yellow
        tabBarView.anchorToView(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,size: .init(width: view.frame.width, height: 50))
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  allIDS[indexPath.item], for:indexPath)
//        if indexPath.item == 3
//        {
//            guard let profileCell = cell as? MainProfileCell else {return cell}
//            profileCell.delegate = self
//        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}
