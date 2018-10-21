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
                    let uid = postVlaue["uid"] as? String ?? ""
                    fetchUserByuid(uid: uid, completitionHandler: { (user) in
                        let audioPost = AudioPost(user:user,dictionary: postVlaue)
                        audioPosts.append(audioPost)
                    })
                    
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
            if let dictionary = snap.value as? [String:Any]
            {
                let user = User(dictionary: dictionary)
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
    func getNotificationByuid(uid:String,completitionHandler:@escaping ([MyNotification]) -> ())
    {
        var allNotifications = [MyNotification]()
        let ref = Database.database().reference().child("notification")
        let query = ref.queryOrdered(byChild: "to").queryEqual(toValue: uid)
        query.keepSynced(true)
        query.observe(.childAdded, with: { (snap) in
            if let dictionary = snap.value as? [String:Any]
            {
                let fromID = dictionary["fromUser"] as? String ?? ""
                self.fetchUserByuid(uid: fromID, completitionHandler: { (user) in
                    let notification = MyNotification(user: user, dictionary: dictionary,id:snap.key)
                    allNotifications.append(notification)
                    completitionHandler(allNotifications)
                })
            }
        }) { (err) in
            print(err)
        }
        query.observe(.childRemoved, with: { (snap) in
           allNotifications = allNotifications.filter({ (notification) -> Bool in
            return notification.notificationID != snap.key
            })
            completitionHandler(allNotifications)
        }) { (err) in
            
        }
    }
    func fetchUserByuid(uid:String,completitionHandler:@escaping (User) -> ())
    {
        let ref = Database.database().reference().child("Users").child(uid)
        ref.keepSynced(true)
        ref.observe(.value, with: { (snap) in
            if let dictionary = snap.value as? [String:Any]
            {
                let user = User(dictionary: dictionary)
                completitionHandler(user)
            }
        }) { (err) in
            
        }
    }
    func fetchFollowingPosts(uid:String,completitionHandler:@escaping ([AudioPost]) -> ())
    {
        var allAudioPosts = [AudioPost]()
        let ref = Database.database().reference().child("following").child(uid)
        ref.keepSynced(true)
        DispatchQueue.global(qos: .userInitiated).async {
        ref.observe(.childAdded, with: { (snap) in
            guard let dictionary = snap.value as? [String:Any] else {return}
            let followinguid = dictionary["following_uid"] as? String ?? ""
            self.fetchUserByuid(uid:followinguid, completitionHandler: { (user) in
                    self.fetchPostusinguid(user: user, completitionHandler: {
                        (audioPosts) in
                        allAudioPosts = audioPosts
                        DispatchQueue.main.async
                        {
                            completitionHandler(allAudioPosts)
                        }
                    })
            })
        }) { (err) in
           print(err)
        }
        }
        
    }
    func fetchPostusinguid(user:User,completitionHandler:@escaping ([AudioPost]) -> ())
    {
        var audioPosts = [AudioPost]()
        let ref = Database.database().reference().child("AudioPosts")
        let query = ref.queryOrdered(byChild: "uid").queryEqual(toValue: user.uid)
        query.keepSynced(true)
        query.observe(.childAdded, with: { (snap) in
            if let dictionary = snap.value as? [String:Any]
            {
                print(dictionary)
                 let audioPost = AudioPost(user: user, dictionary: dictionary)
                audioPosts.append(audioPost)
            }
            completitionHandler(audioPosts)
        }) { (err) in
            
        }
    }
}
