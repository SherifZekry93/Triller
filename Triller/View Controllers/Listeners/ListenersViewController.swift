//
//  Listeners.swift
//  Triller
//
//  Created by Sherif  Wagih on 11/9/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import Firebase
class ListenersViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout
{
    let cellID = "cellID"
    var allFollowers = [Listener]()
    var user:User?{
        didSet{
            self.fetchFollowers { (followers) in
                self.allFollowers = followers
                self.collectionView.reloadData()
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ListenerCell
        cell.user = allFollowers[indexPath.item].user
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allFollowers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 64)
    }
    func setupCollectionView()
    {
        collectionView.register(ListenerCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.backgroundColor  = .white
    }
    func fetchFollowers(completitionHandler: @escaping ([Listener]) -> ())
    {
        var allFollowers = [Listener]()
        guard let userID = user?.uid else {return}
        let ref = Database.database().reference().child("followers").child(userID)
        ref.observe(.value, with: { (snap) in
            allFollowers.removeAll()
            if let dictionaries = snap.value as? [String:Any]
            {
                if snap.value is NSNull
                {
                    completitionHandler(allFollowers)
                    return
                }
                dictionaries.forEach({ (key,value) in
                    if let dictionary = value as? [String:Any]
                    {
                        guard let uid = dictionary["follower_uid"] as? String else {return}
                        FirebaseService.fetchUserByuid(uid: uid, completitionHandler: { (user) in
                            let follower = Listener(user: user, dictionary: dictionary, key: key)
                            allFollowers.append(follower)
                            if allFollowers.count == dictionaries.count
                            {
                                completitionHandler(allFollowers)
                            }
                        })
                    }
                })
            }
        }) { (err) in
            
        }
        
    }
}
