//
//  HashTagCell.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/14/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
class HashTagCell: CommentCell {
    var hashTag:String?{
        didSet
        {
            profileHashTagImage.image = #imageLiteral(resourceName: "hashtag")
            userNameHashTagLabel.text = "HashTag"
        }
    }
}
