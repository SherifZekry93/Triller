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
}
