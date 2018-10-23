//
//  CustomTabBarController.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/13/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
//import SwipeableTabBarController
class MainTabBarController: UITabBarController,UIGestureRecognizerDelegate{
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupViewControllers()
        
        self.tabBar.backgroundColor = UIColor(white: 0.9, alpha: 0.4)
    }
    private var popGesture: UIGestureRecognizer?
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        if navigationController!.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) {
            self.popGesture = navigationController!.interactivePopGestureRecognizer
             self.navigationController!.view.removeGestureRecognizer(navigationController!.interactivePopGestureRecognizer!)
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        if self.popGesture != nil {
            navigationController!.view.addGestureRecognizer(self.popGesture!)
        }
    }
    func setupViewControllers()
    {
        let layout = UICollectionViewFlowLayout()
        let homeNav = UINavigationController(rootViewController: MainHomeFeedController(collectionViewLayout:layout) )
        homeNav.tabBarItem.image = #imageLiteral(resourceName: "home_selected").withRenderingMode(.alwaysTemplate)
        let layout2 = UICollectionViewFlowLayout()
        let searchNav = UINavigationController(rootViewController: SearchController(collectionViewLayout:layout2) )
        searchNav.tabBarItem.image = #imageLiteral(resourceName: "search_selected").withRenderingMode(.alwaysTemplate)
        let layout3 = UICollectionViewFlowLayout()
        let notificationNav = UINavigationController(rootViewController: MainNotificationController(collectionViewLayout:layout3) )
        notificationNav.tabBarItem.image = #imageLiteral(resourceName: "icons8-notification-filled-50").withRenderingMode(.alwaysTemplate)
        notificationNav.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let layout4 = UICollectionViewFlowLayout()

        let profileNav = UINavigationController(rootViewController: MainProfileController(collectionViewLayout:layout4) )
        profileNav.tabBarItem.image = #imageLiteral(resourceName: "profile_selected").withRenderingMode(.alwaysTemplate)        
        viewControllers = [homeNav,searchNav,notificationNav,profileNav]
    }
}
