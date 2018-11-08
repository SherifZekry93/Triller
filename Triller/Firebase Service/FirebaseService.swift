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
            //self.getPostsByHashtag(hashtag: hashTag)
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
    /*func getAllUsers(completitionHandler:@escaping ([User])->())
    {
        var allUsers = [User]()
        let ref = Database.database().reference().child("Users")
        ref.keepSynced(true)
        ref.observeSingleEvent(of:.value) { (snap) in
            if let dictionaries = snap.value as? [String:Any]
            {
                dictionaries.forEach({ (key,value) in
                    if let dictionary = value as? [String:Any]
                    {
                        let user = User(dictionary: dictionary)
                        allUsers.append(user)
                    }
                })
                completitionHandler(allUsers)
            }
            
        }
        /*ref.observe(.childRemoved) { (snap) in
            allUsers = allUsers.filter({ (user) -> Bool in
                return user.uid != snap.key
            })
            completitionHandler(allUsers)
        }*/
        
    }*/
    class func getNotificationByuid(uid:String,completitionHandler:@escaping ([MyNotification]?) -> ())
    {
        var allNotifications = [MyNotification]()
        let ref = Database.database().reference().child("notification")
        let query = ref.queryOrdered(byChild: "to").queryEqual(toValue: "hdcDPY8gSENKkM0Fw31zDbCLdSQ2")
        query.keepSynced(true)
        query.observeSingleEvent(of:.value,with:{snapshot in
            if snapshot.value is NSNull {
                completitionHandler(nil)
            }
            else
            {
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
                    else
                    {
                        completitionHandler(nil)
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
        })
    }
    class func fetchUserByuid(uid:String,completitionHandler:@escaping (User) -> ())
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
    class func fetchFollowingPosts(uid:String,completitionHandler:@escaping ([AudioPost]) -> ())
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
        }
        
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
        var audioPosts = [AudioPost]()
        let ref = Database.database().reference().child("HashTags").child(hashtag.hashTagName)
        ref.observe(.childAdded, with: { (snap) in
            if let dictionary = snap.value as? [String:Any]
            {
                guard let uid = dictionary["uid"] as? String else {return}
                self.fetchUserByuid(uid: uid, completitionHandler: { (user) in
                    self.fetchHashTagPost(user: user, dictionary: dictionary, completitionHandler: { (audioPost) in
                        audioPosts.append(audioPost)
                    })
                    completitionHandler(audioPosts)
                })
            }
        }) { (err) in
            
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
            let query = ref.queryOrdered(byChild: "user_name").queryEqual(toValue: userName)
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
        ref.child(post.audioKey).observe(.value, with: { (snap) in
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
