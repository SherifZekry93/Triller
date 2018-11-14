//
//  CachedPlayer.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/30/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import Foundation
import AVKit
let audioCache = NSCache<AnyObject,AnyObject>()
class CustomAvPlayer
{
    static let shared = CustomAvPlayer()
    var soundURL:String?
    func loadSoundUsingSoundURL(url:URL, completitionHandler: @escaping (Data?) -> ())
    {
        if let soundCached = audioCache.object(forKey: url as AnyObject) as? Data
            {
                print("download from cache")
                completitionHandler(soundCached)
                return
            }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil
                {
                    completitionHandler(nil)
                    return
                }
                DispatchQueue.main.async
                {
                    guard let data = data else {return}
                    audioCache.setObject(data as AnyObject, forKey: url as AnyObject)
                    completitionHandler(data)
                }
                }.resume()
    }
}
