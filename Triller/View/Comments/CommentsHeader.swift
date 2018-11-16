//
//  CommentsHeader.swift
//  Triller
//
//  Created by Sherif  Wagih on 11/3/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
class CommentsHeader: HomeFeedCell {
    
    override func setupViews() {
        isHeader = true
        super.setupViews()
        playAllButton.addTarget(self, action: #selector(playAllComments), for: .touchUpInside)
    }
    
    @objc func playAllComments()
    {
        print("playing")
    }
}
