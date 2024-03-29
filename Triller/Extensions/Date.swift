//
//  Date.swift
//  instagramClone
//
//  Created by Sherif  Wagih on 10/8/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import Foundation
extension Date {
    func timeAgoDisplay() -> String
    {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let year = 12 * month
        let quotient: Int
        let unit: String
        if secondsAgo < minute
        {
            quotient = secondsAgo
            unit = "second"
        }
        else if secondsAgo < hour
        {
            quotient = secondsAgo / minute
            unit = "min"
        }
        else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        }
        else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        }
        else if secondsAgo < month
        {
            quotient = secondsAgo / week
            unit = "week"
        }
        else if secondsAgo < year
        {
            quotient = secondsAgo / month
            unit = "month"
        }
        else
        {
            quotient = secondsAgo / year
            unit = "year"
        }
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
    }
        var millisecondsSince1970:Double {
            return Double((self.timeIntervalSince1970))
        }
        
        init(milliseconds:Int) {
            self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
        }
    

}
