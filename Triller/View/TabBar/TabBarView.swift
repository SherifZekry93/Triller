//
//  TabBar.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/14/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//
/*
import UIKit

protocol TabBarScrollDelegate {
    func tabBarScrollTo(index:Int)
}*/
/*
class TabBarView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    let tabBarCellID = "tabBarCellID"
    var images = [#imageLiteral(resourceName: "home_selected"),#imageLiteral(resourceName: "search_selected"),#imageLiteral(resourceName: "microphone"),#imageLiteral(resourceName: "icons8-notification-filled-50"),#imageLiteral(resourceName: "profile_selected")]
    var delegate:TabBarScrollDelegate?
    var isAnimated = true
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tabBarCellID, for: indexPath) as! TabBarCell
        if indexPath.item == 2
        {
            cell.customButton = true
        }
        else
        {
            cell.customButton = false
        }
        cell.image = images[indexPath.item]
        if indexPath.item == 0
        {
            cell.tabItemImage.tintColor = .orange
            cell.topConstant?.constant = 13
            //cell.topConstant?.constant = 10
            //cell.bottomConstant?.constant = -20
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 5 , height: frame.height)
    }
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupCollectionView()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TabBarCell
        let indexToScroll = indexPath.item
        delegate?.tabBarScrollTo(index: indexToScroll)
        if indexPath.item != 2
        {
            collectionView.indexPathsForVisibleItems.forEach({ (indexPath) in
             let toRemoveSelectionCell =  collectionView.cellForItem(at: indexPath) as! TabBarCell
            toRemoveSelectionCell.tabItemImage.tintColor = .gray
                toRemoveSelectionCell.topConstant?.constant = 15
            })
            cell.topConstant?.constant = 13
            //cell.bottomConstant?.constant = -18
            UIView.animate(withDuration: 0.22, animations: {
                cell.backgroundColor = UIColor(white: 0.7, alpha: 0.3)
                self.layoutIfNeeded()
            }) { (_) in
                UIView.animate(withDuration: 0.3, animations: {
                    cell.backgroundColor = nil
                }, completion: nil)
            }
            cell.tabItemImage.tintColor = .orange
        }
    }
    func setupCollectionView()
    {
        addSubview(collectionView)
        collectionView.anchorToView(top: topAnchor, leading: leftAnchor, bottom: bottomAnchor, trailing: rightAnchor)
        collectionView.backgroundColor = UIColor(white: 0.97, alpha: 1)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TabBarCell.self, forCellWithReuseIdentifier: tabBarCellID)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class TabBarCell: UICollectionViewCell {
    var topConstant:NSLayoutConstraint?
    var bottomConstant:NSLayoutConstraint?
    let tabItemImage:UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var image:UIImage?{
        didSet{
            guard let custom = customButton else {return}
            if !custom
            {
                tabItemImage.tintColor = .gray
                tabItemImage.image = image?.withRenderingMode(.alwaysTemplate)
            }
            else
            {
                tabItemImage.image = image
            }
        }
    }

    var customButton:Bool?{
        didSet{
            guard let custom = customButton else {return}
            setupViews(custom:custom)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    func setupViews(custom:Bool)
    {
        topConstant = tabItemImage.topAnchor.constraint(equalTo: topAnchor,constant:15)
        bottomConstant = tabItemImage.bottomAnchor.constraint(equalTo: bottomAnchor,constant:-15)
        addSubview(tabItemImage)
        if custom
        {
            tabItemImage.anchorToView(top:topAnchor, leading: leftAnchor, bottom: bottomAnchor, trailing: rightAnchor, padding:.init(top: 5, left: 5, bottom: 5, right: 5))
        }
        else
        {
            topConstant?.isActive = true
            bottomConstant?.isActive = true
            tabItemImage.anchorToView(leading: leftAnchor,trailing: rightAnchor,padding:.init(top: 15, left: 15, bottom: 15, right: 15))
        }
            
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
*/
