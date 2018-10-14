//
//  CustomTabBarController.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/13/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import SwipeableTabBarController
protocol TabBarScrollDelegate {
    func tabBarScrollTo(index:Int)
}
class MainTabBarController: UICollectionViewController,UICollectionViewDelegateFlowLayout,TabBarScrollDelegate {
    func tabBarScrollTo(index: Int) {
        if index >= 3
        {
            let indexPath = IndexPath(item: index - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        else if index < 2
        {
            let indexPath = IndexPath(item: index , section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        UIView.animate(withDuration: 0.25)
//        {
//            self.horizontalLine.frame = CGRect(x: scrollView.contentOffset.x / 2, y: 48, width: self.view.frame.width / 2, height: 2)
//        }
//    }
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        var currentpage = x / view.frame.width
        let index = IndexPath(item: Int(currentpage), section: 0)
        if index.item == 2 || index.item == 3
        {
           currentpage += 1
        }
        let indexPath = IndexPath(item: Int(currentpage),section:0)
        tabBarView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        self.tabBarView.collectionView(self.tabBarView.collectionView, didSelectItemAt: indexPath)
    }
    let tabCell = "tabCellID"
    lazy var tabBarView:TabBarView = {
       let tabbar = TabBarView()
        tabbar.delegate = self
       return tabbar
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        view.backgroundColor = .white
        setupTabBar()
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    func setupCollectionView()
    {
        collectionView?.backgroundColor = .gray
        collectionView?.isPagingEnabled = true
        let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: tabCell)
    }
    func setupTabBar()
    {
        view.addSubview(tabBarView)
        tabBarView.backgroundColor = .yellow
        tabBarView.anchorToView(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,size: .init(width: view.frame.width, height: 50))
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tabCell, for: indexPath)
        cell.backgroundColor = indexPath.item % 2 == 0 ? .green:.red
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}
