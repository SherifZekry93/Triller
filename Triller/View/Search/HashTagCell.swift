//
//  HashTagCell.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/14/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
class HashTagCell: TopUserCell {
    var hashTag:HashTag?{
        didSet
        {
            guard let hashTag = hashTag else {return}
            userNameHashTagLabel.text = hashTag.hashTagName
            profileHashTagImage.image = #imageLiteral(resourceName: "hashtag")
        }
    }
}
