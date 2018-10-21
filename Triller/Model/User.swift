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
    let full_name:String
    let full_phone:String
    let location:String
    let phone:String
    let picture:String
    let picture_path:String
    let private_data:PrivateData
    let profile_is_private:Bool
    let status:String
    let uid:String
    let user_name:String
    let user_token:String
    let phone_country:String
    var posts:[AudioPost]
    init(posts:[AudioPost] = [AudioPost](),dictionary:[String:Any]) {
        self.email = dictionary["email"] as?  String ?? ""
        self.full_name = dictionary["full_name"] as?  String ?? ""
        self.full_phone = dictionary["full_phone"] as? String ?? ""
        self.location = dictionary["location"] as? String ?? ""
        self.phone = dictionary["phone"] as? String ?? ""
        self.picture = dictionary ["piicture"] as? String ?? ""
        self.picture_path = dictionary["picture_path"] as? String ?? ""
        self.profile_is_private = dictionary["profile_is_priviate"] as? Bool ?? false
        self.status = dictionary["status"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.user_name = dictionary["user_name"]  as? String ?? ""
        self.user_token = dictionary["user_token"] as? String ?? ""
        self.phone_country = dictionary["phone_country"] as? String ?? ""
        let PrivateDataDictiionary = dictionary["private_data"] as? [String:Any] ?? [String:Any]()
        self.private_data = PrivateData(dictionary: PrivateDataDictiionary)
        self.posts = posts
    }
}
struct PrivateData {
    let birth_date:Date
    let gender:String
    let phone_number:String
    let register_date:Date
    let language:String
    init(dictionary:[String:Any])
    {
        let birthDate = dictionary["birth_date"] as? Double ?? 0
        self.birth_date = Date(timeIntervalSince1970: birthDate)
        self.phone_number = dictionary["phone_number"]  as? String ?? ""
        let registerDate = dictionary["register_date"] as? Double ?? 0
        self.register_date = Date(timeIntervalSince1970: registerDate)
        self.language = dictionary["language"] as? String ?? ""
        self.gender = dictionary["gender"] as? String ?? ""
    }
}
