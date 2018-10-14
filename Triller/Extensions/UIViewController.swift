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
    func detectSwiping()
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
    }

}
