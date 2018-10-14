//
//  HomeController.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/13/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
class HomeController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    let cellID = "cellID"
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //self.recognizeSwipe()
        setupCollectionView()
        setupNavigationController()
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! HomeFeedCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(12, 0, 12, 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    func setupCollectionView()
    {
        collectionView?.backgroundColor = .gray
        collectionView?.register(HomeFeedCell.self, forCellWithReuseIdentifier: cellID)
    }
    func setupNavigationController()
    {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_more_icon").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(handleMoreButton))
        navigationItem.rightBarButtonItem?.tintColor = .black
        let menuBtn = UIButton(type: .custom)
        menuBtn.setImage(UIImage(named:"logo-empty")?.withRenderingMode(.alwaysOriginal), for: .normal)
        menuBtn.addTarget(self, action: #selector(logoSelect), for: UIControlEvents.touchUpInside)
        menuBtn.contentMode = .scaleAspectFit
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        self.navigationItem.leftBarButtonItem = menuBarItem
    }
    @objc func handleMoreButton()
    {
        print("more")
    }
    @objc func logoSelect()
    {
        
    }
}
