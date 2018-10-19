//
//  UIView.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/13/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//
import UIKit
extension UIView
{
    func anchorToView(top : NSLayoutYAxisAnchor? = nil ,left : NSLayoutXAxisAnchor? = nil,bottom : NSLayoutYAxisAnchor? = nil,right : NSLayoutXAxisAnchor? = nil,padding:UIEdgeInsets = .zero,size:CGSize = .zero,centerH:Bool? = false, centerV:Bool? = false)
    {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top
        {
            self.topAnchor.constraint(equalTo: top,constant:padding.top).isActive = true
        }
        if let bottom = bottom
        {
            self.bottomAnchor.constraint(equalTo: bottom,constant:-padding.bottom).isActive = true
        }
        if let right = right
        {
            self.rightAnchor.constraint(equalTo: right,constant:-padding.right).isActive = true
        }
        if let left = left
        {
            self.leftAnchor.constraint(equalTo: left,constant:padding.left).isActive = true
        }
        if size.width != 0
        {
            self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0
        {
            self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        if centerH!
        {
            self.centerXAnchor.constraint(equalTo: (self.superview?.centerXAnchor)!).isActive = true
        }
        if centerV!
        {
            self.centerYAnchor.constraint(equalTo: (self.superview?.centerYAnchor)!).isActive = true
        }
    }
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    func fixSafeArea(color:UIColor)
    {
        guard let window = UIApplication.shared.keyWindow else {return}
        let height = window.safeAreaInsets.bottom
        let viewToFix = UIView()
        viewToFix.backgroundColor = color
        self.addSubview(viewToFix)
        viewToFix.anchorToView(left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, padding: .zero, size: .init(width: 0, height: height))
    }
}
