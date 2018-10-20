//
//  AllHashTags.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/14/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import SVProgressHUD
class AllHashTags: AllUsersCell
{
    let hashtagCellID = "hashtagCellID"
    var allHashTags:[HashTag]?{
        didSet{
            collectionView.reloadData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame:frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupCollectionView() {
        super.setupCollectionView()
        collectionView.register(HashTagCell.self, forCellWithReuseIdentifier: hashtagCellID)
    }
   override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: hashtagCellID, for: indexPath) as! HashTagCell
        cell.hashTag = allHashTags?[indexPath.item]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allHashTags?.count ?? 0
    }
}
