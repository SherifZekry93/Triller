//
//  HashTag.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/20/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import Foundation
class HashTag:NSObject {
    let hashTagName:String
    let audioPosts:[AudioPost]
    init(hashTagName:String,audioPosts:[AudioPost])
    {
        self.hashTagName = hashTagName
        self.audioPosts = audioPosts
    }
}

