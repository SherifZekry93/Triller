//
//  UIViewController.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/14/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
extension UIViewController
{
    func showToast(message : String)
    {
        guard let bottomAreaHeight = UIApplication.shared.keyWindow?.safeAreaInsets.bottom else {return}
        let toastLabel = UILabel(frame: CGRect(x: (view.frame.width / 2) - ((view.frame.width - 100) / 2) , y: self.view.frame.size.height - 100 - bottomAreaHeight, width: view.frame.width - 100, height: 30))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.3, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
