//
//  SearchController.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/14/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import Firebase
protocol SearchForUserOrHashTag {
    func searchForUser(allUsers:[User])
}

class SearchController: UICollectionViewController,UICollectionViewDelegateFlowLayout,UISearchBarDelegate
{
    let commentCellID = "commentCellID"
    let hashTagCellID = "hashTagCellID"
    var cellIDS:[String]!
    let searchController = UISearchController(searchResultsController: nil)
    var allUsers = [User]()
    var filteredUsers = [User]()
    var allHashTags = [HashTag]()
    var filteredHashTags = [HashTag]()
    var searchForTopUsers = true
    var searchForHashTags = false
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchForTopUsers
        {
            if searchText != ""
            {
                filteredUsers = allUsers.filter({ (user) -> Bool in
                    return user.user_name.lowercased().contains(searchText.lowercased())
                })
            }
            else
            {
                filteredUsers = allUsers
            }
        }
        if searchForHashTags
        {
            if searchText != ""
            {
                filteredHashTags =  allHashTags.filter({ (hashTagToSearch) -> Bool in
                    return hashTagToSearch.hashTagName.lowercased().contains(searchText.lowercased())
                })
            }
            else
            {
                filteredHashTags = allHashTags
            }
        }
        self.collectionView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
        self.view.layoutIfNeeded()
        
    }
    func getHashTags()
    {
        FirebaseService.getAllHashTags { (hashtags) in
            hashtags.forEach({ (hash) in
                print(hash.hashTagName)
            })
            self.allHashTags = hashtags
            self.filteredHashTags = hashtags
            self.collectionView.reloadData()
        }
    }
    func getAllUsers()
    {
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        FirebaseService.getAllUsers { (users) in
            
            self.allUsers = users.filter({ (user) -> Bool in
                return user.uid != currentUserID
            })
            
            self.filteredUsers = users
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupMenuBar()
        self.setupCollectionView()
        self.setupSearchController()
        self.getAllUsers()
        self.getHashTags()
        self.setupNavigationController()
        self.extendedLayoutIncludesOpaqueBars = false;
    }
    
    func setupSearchController()
    {
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        self.definesPresentationContext = true
        searchController.searchBar.placeholder = "Search for Friends"
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func setupNavigationController()
    {
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
    }
    func setupCollectionView()
    {
        
        collectionView?.backgroundColor = .white
        collectionView?.isPagingEnabled = true
        let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.register(AllUsersCell.self, forCellWithReuseIdentifier: commentCellID)
        collectionView?.register(AllHashTags.self, forCellWithReuseIdentifier: hashTagCellID)
        cellIDS = [commentCellID,hashTagCellID]
        collectionView.bounces = false
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let height = navigationController?.navigationBar.frame.height  ?? 0
        guard let statusBarHeight = UIApplication.shared.keyWindow?.safeAreaInsets.top else {return .zero}
        let safeaAreaHeight = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        let inset = height + statusBarHeight + safeaAreaHeight
        let bottomSafeAreaHeight = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        if bottomSafeAreaHeight > 0
        {
            return UIEdgeInsets(top: inset + 200 - 12, left: 0, bottom: 0, right: 0)
        }
        else
        {
            return UIEdgeInsets(top: inset + 200 - 24, left: 0, bottom: 0, right: 0)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {

        self.filteredUsers = self.allUsers
        self.filteredHashTags = self.allHashTags
        self.collectionView.reloadData()
        
    }
    let horizontalLine = UIView()
    func setupMenuBar()
    {
        let menuView = UIView()
        view.addSubview(menuView)
        menuView.backgroundColor = .white
        menuView.anchorToView(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size:.init(width: 0, height: 50))
        let horizontalGrayLine = UIView()
        horizontalGrayLine.backgroundColor = .lightGray
        menuView.addSubview(horizontalGrayLine)
        horizontalGrayLine.anchorToView(leading: menuView.leadingAnchor, bottom: menuView.bottomAnchor, trailing: menuView.trailingAnchor, size: .init(width: 0, height: 1))
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
        menuStackView.anchorToView(top: menuView.topAnchor, leading: menuView.leadingAnchor, bottom: menuView.bottomAnchor, trailing: menuView.trailingAnchor)
        horizontalLine.backgroundColor = .orange
        horizontalLine.frame = CGRect(x: 0, y: 48, width: view.frame.width / 2, height: 2)
        menuView.addSubview(horizontalLine)
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        UIView.animate(withDuration: 0.25)
        {
            self.horizontalLine.frame = CGRect(x: scrollView.contentOffset.x / 2, y: 48, width: self.view.frame.width / 2, height: 2)
        }
    }
    @objc func scrollToIndex(_ sender:UIButton)
    {
        UIView.animate(withDuration: 0.32, animations:
            {
                let indexPath = IndexPath(item: sender.tag, section: 0)
                sender.backgroundColor = UIColor(white: 0.7, alpha: 0.3)
                self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        ) { (completed) in
            UIView.animate(withDuration: 0.32, animations: {
                sender.backgroundColor = nil
            }, completion: nil)
        }
        if sender.tag == 0
        {
            searchForTopUsers = true
            searchForHashTags = false
            searchController.searchBar.placeholder = "Search for Friends"
        }
        else if sender.tag == 1
        {
            searchForHashTags = true
            searchForTopUsers = false
            searchController.searchBar.placeholder = "Search for HashTag"
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIDS[indexPath.item], for: indexPath)
        if indexPath.item == 0
        {
            if let AllUsersCell = (cell as? AllUsersCell)
            {
                AllUsersCell.allUsers = filteredUsers
                AllUsersCell.homeController = self
            }
        }
        else
        {
            if let AllHashTags = (cell as? AllHashTags)
            {
                AllHashTags.allHashTags = filteredHashTags
                AllHashTags.homeController = self
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}
