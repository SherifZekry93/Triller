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
    //static let shared = FirebaseService()
    class func getAllHashTags(completitionHandler:@escaping ([HashTag]) -> ())
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
            let hashTag = HashTag(hashTagName: snap.key)
            allHashtags.append(hashTag)
            completitionHandler(allHashtags)
        }) { (err) in
        }
    }
    class func getAllUsers(completitionHandler:@escaping ([User])->())
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
    class func getNotificationByuid(uid:String,completitionHandler:@escaping ([MyNotification]?) -> ())
    {
        var allNotifications = [MyNotification]()
        let ref = Database.database().reference().child("notification")
        let query = ref.queryOrdered(byChild: "to").queryEqual(toValue: uid)
        query.keepSynced(true)
        query.observe(.childAdded, with: { (snap) in
            if let dictionary = snap.value as?  [String:Any]
            {
                guard let uid = dictionary["fromUser"] as? String else {return}
                fetchUserByuid(uid: uid , completitionHandler: { (user) in
                    let notification = MyNotification(user: user, dictionary: dictionary, id: snap.key)
                    allNotifications.append(notification)
                    completitionHandler(allNotifications)
                })
            }
        }) { (err) in
            
        }
           }
    class func fetchUserByuid(uid:String,completitionHandler:@escaping (User) -> ())
    {
        let ref = Database.database().reference().child("Users").child(uid)
        ref.keepSynced(true)
        ref.observe(.value, with: { (snap) in
         //   print(snap)
            if let dictionary = snap.value as? [String:Any]
            {
                let user = User(dictionary: dictionary)
                completitionHandler(user)
            }
        }) { (err) in
            
        }
    }
    class func fetchFollowingPosts(uid:String,completitionHandler:@escaping ([AudioPost]) -> ())
    {
        var allAudioPosts = [AudioPost]()
        let ref = Database.database().reference().child("AudioPosts")
        ref.observe(.value, with: { (snap) in
            allAudioPosts.removeAll()
            if snap.value is NSNull
            {
                completitionHandler(allAudioPosts)
            }
            else
            {
                if let dictionaries = snap.value as? [String:Any]
                {
                    dictionaries.forEach({ (key,value) in
                        if let dictionary = value as? [String:Any]
                        {
                            guard let uid = dictionary["uid"] as? String else {return}
                            self.fetchUserByuid(uid: uid, completitionHandler: { (user) in
                                let post = AudioPost(user: user, dictionary: dictionary)
                                post.audioKey = key
                                allAudioPosts.append(post)
                                if allAudioPosts.count == dictionaries.count
                                {
                                    completitionHandler(allAudioPosts)
                                }
                            })
                        }
                    })
                }
            }
        }) { (err) in
            
        }
        /*var allAudioPosts = [AudioPost]()
        let ref = Database.database().reference().child("following").child(uid)
        ref.keepSynced(true)
        DispatchQueue.global(qos: .userInitiated).async {
            allAudioPosts.removeAll()
            ref.observe(.childAdded, with: { (snap) in
                if snap.value is NSNull
                {
                    completitionHandler(allAudioPosts)
                }
                guard let dictionary = snap.value as? [String:Any] else {return}
                let followinguid = dictionary["following_uid"] as? String ?? ""
                self.fetchUserByuid(uid:followinguid, completitionHandler: {
                    (user) in
                    allAudioPosts.removeAll()
                    self.fetchPostusinguid(user: user, completitionHandler: {
                        (audioPosts) in
                        allAudioPosts.removeAll()
                        audioPosts.forEach({ (post) in
                            allAudioPosts.append(post)
                        })
                        DispatchQueue.main.async
                        {
                                completitionHandler(allAudioPosts)
                        }
                    })
                })
            }) { (err) in
                print(err)
            }
            ref.observe(.childRemoved, with: { (snap) in
                if let dictionary = snap.value as? [String:Any]
                {
                    allAudioPosts = allAudioPosts.filter({ (audioPost) -> Bool in
                        return audioPost.uid != dictionary["following_uid"] as? String
                    })
                }
                completitionHandler(allAudioPosts)
            }) { (err) in
                print(err)
            }
        }*/
    }
    class func fetchPostusinguid(user:User,completitionHandler:@escaping ([AudioPost]) -> ())
    {
        var audioPosts = [AudioPost]()
        let ref = Database.database().reference().child("AudioPosts")
        let query = ref.queryOrdered(byChild: "uid").queryEqual(toValue: user.uid)
        query.keepSynced(true)
        query.observe(.value, with: { (snap) in
            audioPosts.removeAll()
            if let dictionary = snap.value as? [String:Any]
            {
                dictionary.forEach({ (key,value) in
                    if let dict = value as? [String:Any]
                    {
                        
                        let audioPost = AudioPost(user: user, dictionary: dict)
                        audioPost.audioKey = key
                        audioPosts.append(audioPost)
                    }
                })
            }
            completitionHandler(audioPosts)
        }) { (err) in
            
        }
    }
    class func getPostsByHashtag(hashtag:HashTag,completitionHandler:@escaping ([AudioPost]) -> ())
    {
        var allAudioPosts = [AudioPost]()
        let ref = Database.database().reference().child("HashTags").child(hashtag.hashTagName)
        ref.observe(.value) { (snap) in
            
            allAudioPosts.removeAll()
            if snap.value is NSNull
            {
               completitionHandler(allAudioPosts)
            }
            else if let dictionaries = snap.value as? [String:Any]
            {
                dictionaries.forEach({ (key,value) in
                    if let dictionary = value as? [String:Any]
                    {
                    guard let uid = dictionary["uid"] as? String else {return}
                    
                    self.fetchUserByuid(uid: uid, completitionHandler: { (user) in
                        
                        let post = AudioPost(user: user, dictionary: dictionary)
                        post.audioKey = key
                        allAudioPosts.append(post)
                        if dictionaries.count == allAudioPosts.count
                        {
                            completitionHandler(allAudioPosts)
                        }
                    })
                    }
                })
            }
        }
    }
    class func fetchHashTagPost(user:User,dictionary:[String:Any],completitionHandler:(AudioPost) -> ())
    {
        let audioPost = AudioPost(user: user, dictionary: dictionary)
        completitionHandler(audioPost)
    }
    
    class func getUserBy(userName:String,completitionHandler:@escaping (User?) -> ())
    {
        let ref = Database.database().reference().child("Users")
        if userName != ""
        {
            let query = ref.queryOrdered(byChild: "user_name").queryEqual(toValue: userName.lowercased())
            query.observe(.value) { (snap) in
                if snap.value is NSNull
                {
                    completitionHandler(nil)
                }
            }
            query.observeSingleEvent(of:.childAdded, with: { (snap) in
                if let dictionary = snap.value as? [String:Any]
                {
                    let user = User(dictionary: dictionary)
                    completitionHandler(user)
                }
                else
                {
                    completitionHandler(nil)
                }
            }) { (err) in
                
            }
        }
    }
    
    class func getUserBy(phoneNumber:String,completitionHandler:@escaping (User?) -> ())
    {
        let ref = Database.database().reference().child("Users")
        if phoneNumber != ""
        {
            let query = ref.queryOrdered(byChild: "phone").queryEqual(toValue: phoneNumber)
            query.observeSingleEvent(of:.value, with: { (snap) in
                if snap.value is NSNull {
                    completitionHandler(nil)
                }
                else
                {
                    if let dictionary = snap.value as? [String:Any]
                    {
                        dictionary.forEach({ (key,value) in
                            if let innerdict = value as? [String:Any]
                            {
                                let user = User(dictionary: innerdict)
                                completitionHandler(user)
                            }
                            else
                            {
                                completitionHandler(nil)
                            }
                        })
                        
                    }
                    else
                    {
                        completitionHandler(nil)
                    }
                }
            }) { (err) in
                
            }
        }
    }
    class func getCommentsByPostID(post:AudioPost,completitioinHandler:@escaping ([Comment]) ->())
    {
        var allComments = [Comment]()
        let ref = Database.database().reference().child("Comments")
        ref.keepSynced(true)
        ref.child(post.audioKey).observe(.value, with: { (snap) in
            allComments.removeAll()
            if snap.value is NSNull
            {
                completitioinHandler(allComments)
                return
            }
            if let dictioinaries = snap.value as? [String:Any]
            {
                dictioinaries.forEach({ (key,value) in
                    if let dict = value as? [String:Any]
                    {
                        guard let uid = dict["uid"] as? String else {return}
                        fetchUserByuid(uid: uid, completitionHandler: { (user) in
                            let comment = Comment(key: key, user: user, dictionary: dict)
                            allComments.append(comment)
                            if allComments.count == dictioinaries.count
                            {
                                completitioinHandler(allComments)
                            }
                        })
                    }
                })
            }
        }) { (err) in
            
        }
    }
}
