//
//  Follower.swift
//  Triller
//
//  Created by Sherif  Wagih on 11/9/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import Foundation
struct Listener {
    let followerKey:String
    let create_date:Date //= "1541732882.723976";
    let follower_uid:String// = 9YKlvgUHKlQZzWxjwklhUqjCqFq1;
    var user:User
    init(user:User,dictionary:[String:Any],key:String) {
        self.followerKey = key
        self.user = user
        let date = dictionary["create_date"] as? Double ?? 0
        self.create_date = Date(timeIntervalSince1970: date)
        self.follower_uid = dictionary["follower_uid"] as? String ?? ""
    }
}
