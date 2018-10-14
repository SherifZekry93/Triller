//
//  AllHashTags.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/14/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
class AllHashTags: AllCommentsCell
{
    let hashtagCellID = "hashtagCellID"
    override func setupCollectionView() {
        super.setupCollectionView()
        collectionView.register(HashTagCell.self, forCellWithReuseIdentifier: hashtagCellID)
    }
   override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: hashtagCellID, for: indexPath) as! HashTagCell
        cell.hashTag = "   "
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}
