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
    /*func detectSwiping()
     {
     let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
     let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
     leftSwipe.direction = .left
     rightSwipe.direction = .right
     self.view.addGestureRecognizer(leftSwipe)
     self.view.addGestureRecognizer(rightSwipe)
     }
     @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
     if sender.direction == .left {
     UIView.animate(withDuration: 0.3) {
     self.tabBarController!.selectedIndex += 1
     }
     }
     if sender.direction == .right {
     UIView.animate(withDuration: 0.3) {
     self.tabBarController!.selectedIndex -= 1
     }
     }
     }*/
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 125, y: self.view.frame.size.height-100, width: 250, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
