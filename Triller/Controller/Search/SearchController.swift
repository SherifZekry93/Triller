//
//  SearchController.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/14/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
class SearchController: UICollectionViewController,UICollectionViewDelegateFlowLayout{
    let commentCellID = "commentCellID"
    let hashTagCellID = "hashTagCellID"
    var cellIDS:[String]!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupNavigationController()
        setupCollectionView()
        setupMenuBar()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func setupNavigationController()
    {
        view.backgroundColor = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Hello"
    }
    func setupCollectionView()
    {
        collectionView?.backgroundColor = .white
        collectionView?.isPagingEnabled = true
        let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.register(AllCommentsCell.self, forCellWithReuseIdentifier: commentCellID)
        collectionView?.register(AllHashTags.self, forCellWithReuseIdentifier: hashTagCellID)
        cellIDS = [commentCellID,hashTagCellID]
        collectionView?.alwaysBounceVertical = false;
        collectionView?.alwaysBounceHorizontal = false;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 150, left: 0, bottom: 0, right: 0)
    }
    let horizontalLine = UIView()
    func setupMenuBar()
    {
        let menuView = UIView()
        view.addSubview(menuView)
        menuView.anchorToView(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, padding: .zero,size:.init(width: 0, height: 50))
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
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //        targetContentOffset.pointee = scrollView.contentOffset
        //        let x = targetContentOffset.pointee.x
        //        UIView.animate(withDuration: 0.25)
        //        {
        //            self.horizontalLine.frame = CGRect(x: x / 2, y: 48, width: self.view.frame.width / 2, height: 2)
        //        }
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
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIDS[indexPath.item], for: indexPath)
        cell.backgroundColor = indexPath.item % 2 == 0 ? .red :.green
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    var stackSearchViewTitle:UIStackView = UIStackView()
    let searchLabel = UITextField()
    let searchIcon = UIImageView(image: #imageLiteral(resourceName: "search_selected"))
    var searchMode:Bool = false
    func setupSearchController()
    {
        originalTextView()
    }
    @objc func switchTexts()
    {
        if !searchMode
        {
            switchToEnabledText()
            searchMode = true
        }
        else
        {
            searchMode = false
            originalTextView()
        }
    }
    func switchToEnabledText()
    {
        searchIcon.image = #imageLiteral(resourceName: "cancel-shadow").withRenderingMode(.alwaysOriginal)
        searchIcon.isUserInteractionEnabled = true
        searchIcon.tintColor = .black
        searchLabel.text = ""
        searchLabel.leftViewMode = UITextFieldViewMode.always
        searchLabel.isEnabled = true
        let imageView = UIImageView(frame: CGRect(x: -20, y: 0, width: 20, height: 20))
        let image = #imageLiteral(resourceName: "search_selected")
        imageView.image = image
        searchLabel.leftView = imageView
        searchLabel.placeholder = " Search For Stupid stuff"
    }
    func originalTextView()
    {
        searchLabel.text = "Search"
        searchLabel.textColor = .darkGray
        searchLabel.font = UIFont.boldSystemFont(ofSize: 20)
        searchLabel.isEnabled = false
        searchLabel.addTarget(self, action: #selector(startSearching), for: .editingChanged)
        searchIcon.isUserInteractionEnabled = true
        searchIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(switchTexts)))
        stackSearchViewTitle = UIStackView(arrangedSubviews: [searchLabel,searchIcon])
        view.addSubview(stackSearchViewTitle)
        stackSearchViewTitle.anchorToView(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, padding: .init(top: 8, left: 20, bottom: 0, right: 12), size: .init(width: 0, height: 40))
        searchLabel.leftViewMode = UITextFieldViewMode.never
        searchIcon.image = #imageLiteral(resourceName: "search_selected")
    }
    @objc func startSearching(_ sender:UITextField)
    {
        sender.leftView = nil
        if sender.text == ""
        {
            searchLabel.leftViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: -20, y: 0, width: 20, height: 20))
            let image = #imageLiteral(resourceName: "search_selected")
            imageView.image = image
            searchLabel.leftView = imageView
        }
    }
}
