//
//  String.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/22/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import Foundation
extension String
{
    func getLanguage() -> String
    {
        let text = self
        
        if let language = NSLinguisticTagger.dominantLanguage(for: text)
        {
            return language
        }
        else {
            return "Unknown language"
        }
    }
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    func findMentionText() -> [String] {
        var arr_hasStrings:[String] = []
        let regex = try? NSRegularExpression(pattern: "(#[a-zA-Z0-9_\\p{Arabic}\\p{N}]*)", options: [])
        if let matches = regex?.matches(in: self, options:[], range:NSMakeRange(0, self.count)) {
            for match in matches {
                arr_hasStrings.append(NSString(string: self).substring(with: NSRange(location:match.range.location, length: match.range.length )))
            }
        }
        return arr_hasStrings
    }
}
