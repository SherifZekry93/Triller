//
//  LeftPaddedTextField.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/14/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
class LeftPaddedTextField: UITextField
{
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x +  5, y: bounds.origin.y, width: bounds.width - 20, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
         return CGRect(x: bounds.origin.x +  5, y: bounds.origin.y, width: bounds.width - 20, height: bounds.height)
    }
}
