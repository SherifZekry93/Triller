//
//  SpeakerViewController.swift
//  Triller
//
//  Created by Sherif  Wagih on 11/9/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import Firebase
class SpeakerViewController:UICollectionViewController,UICollectionViewDelegateFlowLayout
{
    let cellID = "CellID"
    var allSpeakers = [Speaker]()
    var user:User?{
        didSet{
            getAllSpeakers()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
       DispatchQueue.main.async {
        self.navigationController?.navigationBar.isHidden = false
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allSpeakers.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ListenerCell
        cell.user = allSpeakers[indexPath.item].user
        return cell
    }
    func setupCollectionView()
    {
        collectionView.backgroundColor = .white
        collectionView.register(ListenerCell.self, forCellWithReuseIdentifier: cellID)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    func fetchFollowers(completitionHandler: @escaping ([Speaker]) -> ())
    {
        var speakers = [Speaker]()
        guard let userID = user?.uid else {return}
        let ref = Database.database().reference().child("following").child(userID)
        ref.observe(.value, with: { (snap) in
            speakers.removeAll()
            if snap.value is NSNull
            {
                completitionHandler(speakers)
                return
            }
            if let dictionaries = snap.value as? [String:Any]
            {
                dictionaries.forEach({ (key,value) in
                    if let dictionary = value as? [String:Any]
                    {
                        guard let uid = dictionary["following_uid"] as? String else {return}
                        
                        FirebaseService.fetchUserByuid(uid: uid, completitionHandler: { (user) in
                            let follower = Speaker(user: user, dictionary: dictionary, key: key)
                            speakers.append(follower)
                            if speakers.count == dictionaries.count
                            {
                                completitionHandler(speakers)
                            }
                        })
                            
                        
                    }
                })
            }
        })
        { (err) in
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 64)
    }
    func getAllSpeakers()
    {
        fetchFollowers { (speakers) in
            self.allSpeakers = speakers
            self.collectionView.reloadData()
        }
    }

}
