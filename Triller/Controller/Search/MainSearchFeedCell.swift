//
//  MainSearchFeedCell.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/14/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
class MainSearchFeedCell: BaseCell,UICollectionViewDataSource {
    let cellID = "cellID"
    let commentCellID = "commentCellID"
    let hashTagCellID = "hashTagCellID"
    var cellIDS:[String] = ["commentCellID","hashTagCellID"]
    
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    let horizontalLine = UIView()
    func setupMenuBar()
    {
        let menuView = UIView()
        addSubview(menuView)
        menuView.backgroundColor = .white
        menuView.anchorToView(top: collectionView.topAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size:.init(width: 0, height: 50))
        let horizontalGrayLine = UIView()
        horizontalGrayLine.backgroundColor = .lightGray
        menuView.addSubview(horizontalGrayLine)
        horizontalGrayLine.anchorToView(left: menuView.leftAnchor, bottom: menuView.bottomAnchor, right: menuView.rightAnchor, size: .init(width: 0, height: 1))
        let searchForFriendsButton = UIButton()
        searchForFriendsButton.setTitle("TOP", for: .normal)
        searchForFriendsButton.setTitleColor(.black, for: .normal)
        searchForFriendsButton.tag = 0
        searchForFriendsButton.addTarget(self, action: #selector(scrollToIndex), for: .touchUpInside)
        let searchForHashTagButton = UIButton()
        searchForHashTagButton.setTitle("HASH TAGS", for: .normal)
        searchForHashTagButton.setTitleColor(.black, for: .normal)
        searchForHashTagButton.tag = 1
        searchForHashTagButton.addTarget(self, action: #selector(scrollToIndex), for: .touchUpInside)
        let menuStackView = UIStackView(arrangedSubviews: [searchForFriendsButton,searchForHashTagButton])
        menuStackView.distribution = .fillEqually
        menuView.addSubview(menuStackView)
        menuStackView.anchorToView(top: menuView.topAnchor, left: menuView.leftAnchor, bottom: menuView.bottomAnchor, right: menuView.rightAnchor)
        horizontalLine.backgroundColor = .orange
        horizontalLine.frame = CGRect(x: 0, y: 48, width: frame.width / 2, height: 2)
        menuView.addSubview(horizontalLine)
    }
    @objc func scrollToIndex(_ sender:UIButton)
    {
        UIView.animate(withDuration: 0.32, animations:
            {
                let indexPath = IndexPath(item: sender.tag, section: 0)
                sender.backgroundColor = UIColor(white: 0.7, alpha: 0.3)
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        ) { (completed) in
            UIView.animate(withDuration: 0.32, animations: {
                sender.backgroundColor = nil
            }, completion: nil)
        }
    }
    func setupCollectionView()
    {
        addSubview(collectionView)
        collectionView.anchorToView(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(AllCommentsCell.self, forCellWithReuseIdentifier: commentCellID)
        collectionView.register(AllHashTags.self, forCellWithReuseIdentifier: hashTagCellID)
        cellIDS = [commentCellID,hashTagCellID]
        collectionView.alwaysBounceVertical = false;
        collectionView.alwaysBounceHorizontal = false;
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIDS[indexPath.item], for: indexPath)
        cell.backgroundColor = indexPath.item % 2 == 0 ? .red :.green
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        UIView.animate(withDuration: 0.25)
        {
            self.horizontalLine.frame = CGRect(x: scrollView.contentOffset.x / 2, y: 48, width: self.frame.width / 2, height: 2)
        }
    }
    override func setupViews() {
        setupCollectionView()
        setupMenuBar()
    }
}
