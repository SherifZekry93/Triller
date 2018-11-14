//
//  MediteItem.swift
//  Triller
//
//  Created by Sherif  Wagih on 11/5/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import Foundation
class MediaItem {
    var audioKey:String
    var audioDuration:Double
    var audioName:String
    var audioURL:String
    var creationDate:Date
    var uid:String
    var user:User?
    var hasLiked:Bool = false
    init() {
        self.audioKey = ""
        self.audioDuration = 0
        self.audioName = ""
        self.audioURL = ""
        self.creationDate = Date()
        self.uid = ""
        self.user  = nil
    }
}
