//
//  HomeFeedCell.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/14/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
class MainHomeFeedCell: BaseCell,UICollectionViewDataSource
    {
    let cellID = "cellID"
    let navigationCellID = "navigationCellID"
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 12
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: navigationCellID, for: indexPath)
        header.backgroundColor = UIColor(red: 254/255, green: 254/255, blue: 254/255, alpha: 1)
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: frame.width, height: 44)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 220)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let  height = UIApplication.shared.statusBarFrame.height
        return UIEdgeInsets.init(top: 10, left: 0, bottom: height + 50 + 10, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for:indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    override func setupViews() {
        setupCollectionView()
    }
    func setupCollectionView()
    {
        addSubview(collectionView)
        collectionView.anchorToView(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        collectionView.register(HomeFeedCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(HomeNavigationCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: navigationCellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        backgroundColor = .lightGray
        collectionView.backgroundColor = .lightGray
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
    }
}
