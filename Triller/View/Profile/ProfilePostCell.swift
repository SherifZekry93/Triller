//
//  ProfilePostCell.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/14/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
class ProfilePostCell: HomeFeedCell {
    var homeController:MainProfileController?
    override func handlePostMenu() {
        showEditShare()
    }
    override func showEditShare() {
        let alert = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
        
        alert.view.frame = CGRect(x: alert.view.frame.origin.x, y:
            self.homeController?.view.frame.height ?? 0 / 2, width: alert.view.frame.width, height: alert.view.frame.height);
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            let deleteAlert = UIAlertController(title: nil, message: "Are you sure you want to delete this?", preferredStyle: UIAlertController.Style.alert)
            
            deleteAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (Action) in
                guard let post = self.post else {return}
                print(post.audioKey)
                let ref = Database.database().reference().child("AudioPosts")
                ref.child(post.audioKey).removeValue { (err, ref) in
                    if err != nil
                    {
                        ProgressHUD.showError(err?.localizedDescription)
                    }
                    self.homeController?.collectionView.reloadData()
                };
            }))
            
            deleteAlert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { (alert) in
                self.homeController?.dismiss(animated: true, completion: nil)
            }))
            self.homeController?.present(deleteAlert, animated: true, completion: nil)
        }
        let shareAction = UIAlertAction(title: "Share", style: .default) { (action) in
        }
        
        alert.addAction(deleteAction)
        alert.addAction(shareAction)
        self.homeController?.present(alert, animated: true){
            alert.view.superview?.subviews.first?.isUserInteractionEnabled = true
            alert.view.superview?.subviews.first?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.actionSheetBackgroundTapped)))
            
        }
        
    }
    @objc func actionSheetBackgroundTapped() {
        self.homeController?.dismiss(animated: true, completion: nil)
    }
    
}
