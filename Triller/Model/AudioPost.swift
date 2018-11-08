//
//  AudioPost.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/20/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import Foundation
class AudioPost:MediaItem {
    //let audioName:String
    //let audioURL:String
    //let creationDate:Date
    //let uid:String
    //var user:User
    var audioNote:String = ""
    init(user:User,dictionary:[String:Any]) {
        super.init()
        self.audioDuration = dictionary["audioDuration"] as? Double ?? 0
        self.audioName = dictionary["audioName"] as? String ?? ""
        self.audioURL = dictionary["audioUri"] as? String ?? ""
        self.audioNote = dictionary["audioNote"] as? String ?? ""
        let date = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: date)
        self.uid = dictionary["uid"] as? String ?? ""
        self.user = user
        self.audioKey = ""
    }
}
