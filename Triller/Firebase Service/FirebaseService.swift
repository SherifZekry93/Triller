//
//  FirebaseService.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/20/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import Firebase
class FirebaseService
{
    static let shared = FirebaseService()
    func getAllHashTags(completitionHandler:@escaping ([HashTag]) -> ())
    {
        var allHashtags = [HashTag]()
        let ref = Database.database().reference().child("HashTags")
        ref.keepSynced(true)
        ref.observe(.childRemoved, with: { (snap) in
            allHashtags = allHashtags.filter({ (hashtag) -> Bool in
                return hashtag.hashTagName != snap.key
            })
            completitionHandler(allHashtags)
        }) { (err) in
        }
        
        ref.observe(.childAdded, with: { (snap) in
            let hashTag = self.allHashTagsObserver(snap:snap)
            allHashtags.append(hashTag)
            completitionHandler(allHashtags)
        }) { (err) in
        }
    }
    func allHashTagsObserver(snap:DataSnapshot) -> HashTag
    {
        var audioPosts = [AudioPost]()
        var hashtag = HashTag(hashTagName: "", audioPosts: audioPosts)
        if let dictionaries = snap.value as? [String:Any]
        {
            dictionaries.forEach({ (key,value) in
                if let postVlaue = value as? [String:Any]
                {
                    let audioPost = AudioPost(dictionary: postVlaue)
                    audioPosts.append(audioPost)
                }
            })
            hashtag = HashTag(hashTagName: snap.key, audioPosts: audioPosts)
        }
        return hashtag
    }
    func getAllUsers(completitionHandler:@escaping ([User])->())
    {
        var allUsers = [User]()
        let ref = Database.database().reference().child("Users")
        ref.keepSynced(true)
        ref.observe(.childAdded) { (snap) in
            if let value = snap.value as? [String:Any]
            {
                let user = User(dictionary: value)
                allUsers.append(user)
            }
            completitionHandler(allUsers)
        }
        ref.observe(.childRemoved) { (snap) in
            allUsers = allUsers.filter({ (user) -> Bool in
                return user.uid != snap.key
            })
            completitionHandler(allUsers)
        }
    }
}
