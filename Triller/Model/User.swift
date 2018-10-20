//
//  User.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/20/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import Foundation
struct User {
    let email:String
    let fullName:String
    let full_phone:String
    let location:String
    let phone:String
    let picture:String
    let picture_path:String
    let private_data:PrivateData
    let profile_is_private:Bool = false
    let status:String
    let uid:String
    let user_name:String
    let user_token:String
}
struct PrivateData {
    
}
