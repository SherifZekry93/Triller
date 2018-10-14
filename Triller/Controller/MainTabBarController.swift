//
//  CustomTabBarController.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/13/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    func setupViewControllers()
    {
        let homeController = HomeController(collectionViewLayout: UICollectionViewFlowLayout())
        let homeNavController = UINavigationController(rootViewController: homeController)
        homeNavController.tabBarItem.image = #imageLiteral(resourceName: "home_selected").withRenderingMode(.alwaysTemplate)
        let searchController = SearchController(collectionViewLayout: UICollectionViewFlowLayout())
       let searchNav = UINavigationController(rootViewController: searchController)
        searchNav.tabBarItem.image = #imageLiteral(resourceName: "search_unselected")
        tabBar.tintColor = .gray
        viewControllers = [searchNav,homeNavController]
        guard let tabarItems = tabBar.items else {return}
        for item in tabarItems
        {
            item.imageInsets = .init(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
}
