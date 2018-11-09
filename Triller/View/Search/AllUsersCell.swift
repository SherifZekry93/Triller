//
//  CommentCell.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/14/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import ProgressHUD
class AllUsersCell: UICollectionViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    let cellID = "cellID"
    var allUsers:[User]?{
        didSet{
            DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.layoutSubviews()
            }
       }
    }
    var homeController:SearchController?
    var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let layout = UICollectionViewFlowLayout()
        let profileController = MainProfileController(collectionViewLayout:layout)
        profileController.user = allUsers?[indexPath.item]//.uid;
 homeController?.navigationController?.pushViewController(profileController, animated: true)
    }
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupCollectionView()
    }
    func setupCollectionView()
    {
        addSubview(collectionView)
        collectionView.anchorToView(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TopUserCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.bounces = false
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let height = self.homeController?.tabBarController?.tabBar.frame.height ?? 0
        let safeaAreaHeight = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        let inset = height  + safeaAreaHeight
        if safeaAreaHeight > 0
        {
            return UIEdgeInsets(top: 0, left: 0, bottom: inset + 150 + 6 , right: 0)
        }
        else
        {
            return UIEdgeInsets(top: 0, left: 0, bottom: inset + 150 + 12  , right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allUsers?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! TopUserCell
        cell.user = allUsers?[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 65)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
