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
        ref.observe(.childAdded, with: { (snap) in
            var audioPosts = [AudioPost]()
            if let dictionaries = snap.value as? [String:Any]
            {
                dictionaries.forEach({ (key,value) in
                    if let postVlaue = value as? [String:Any]
                    {
                        let audioPost = AudioPost(dictionary: postVlaue)
                        audioPosts.append(audioPost)
                    }
                })
                let hashTag = HashTag(hashTagName: snap.key, audioPosts: audioPosts)
                allHashtags.append(hashTag)
                completitionHandler(allHashtags)
            }
        }) { (err) in
            
        }
    }
}
