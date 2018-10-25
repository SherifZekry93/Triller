//
//  MainNotificationCell.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/14/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import Firebase
class MainNotificationController:UICollectionViewController, UICollectionViewDelegateFlowLayout{
    let cellID = "cellID"
    let notificationHeaderID = "notificationHeaderID"
    var notifications:[MyNotification] = [MyNotification]()
    var loadedData = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationController()
        if let currentuid = Auth.auth().currentUser?.uid
        {
            loadNotificationByuid(uid:currentuid)
        }
    }
    func loadNotificationByuid(uid:String)
    {
         FirebaseService.shared.getNotificationByuid(uid: uid) { (allNotifications) in
            if let notifications = allNotifications
            {
                self.notifications = notifications
            }
            self.loadedData = true
            self.collectionView.reloadData()
         }
    }
    func setupNavigationController()
    {
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Notification"
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func setupCollectionView(){
        collectionView.backgroundColor = .white
        collectionView.register(NotificationCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(NotificationHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: notificationHeaderID)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: notificationHeaderID, for: indexPath)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if notifications.count == 0 && loadedData == true
        {
            return CGSize(width: view.frame.width, height: 244)
        }
        return .zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return notifications.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 74)
    }
}
