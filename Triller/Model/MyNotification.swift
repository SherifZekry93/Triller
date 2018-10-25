//
//  Notification.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/21/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import Foundation
class MyNotification
{
    let notificationID:String
    let creationDate:Date
    let fromUser:String
    let hashID:String
    let to:String
    let type:String
    let user:User
    init(user:User,dictionary:[String:Any],id:String)
    {
        let date = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: date)
        self.fromUser = dictionary["fromUser"] as?  String ?? ""
        self.hashID = dictionary["hashID"] as?  String ?? ""
        self.to = dictionary["to"] as?  String ?? ""
        self.type = dictionary["type"] as?  String ?? ""
        self.user = user
        self.notificationID = id
    }
    
}
