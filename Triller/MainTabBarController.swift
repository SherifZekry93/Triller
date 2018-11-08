//
//  CustomTabBarController.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/13/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
//import SwipeableTabBarController
import IQAudioRecorderController
class MainTabBarController: UITabBarController,UIGestureRecognizerDelegate,UITabBarControllerDelegate,IQAudioRecorderViewControllerDelegate{
    func audioRecorderController(_ controller: IQAudioRecorderViewController, didFinishWithAudioAtPath filePath: String) {
        let someV = ShareAudioViewController()
        someV.filePath = filePath
        present(UINavigationController(rootViewController: someV), animated: true) {
              self.dismiss(animated: true)
        }
       
    }
    func audioRecorderControllerDidCancel(_ controller: IQAudioRecorderViewController) {
        dismiss(animated: true, completion: nil)
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController)
        if index == 2
        {
            let audioController = AudioRecorderView(delegate_:self)
            audioController.PresentAudioRecorder(target: self)
            return false
        }
        return true
    }
    let customBackGroundView = UIView()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.delegate = self
        setupViewControllers()
        DispatchQueue.main.async {
            self.createCustomStatusBar(color: .blue)
        }
        self.tabBar.backgroundColor = UIColor(white: 0.9, alpha: 0.4)
    }
    override func viewDidLayoutSubviews() {
        self.navigationController?.navigationBar.isHidden = true
    }
    func createCustomStatusBar(color:UIColor){
       
        customBackGroundView.backgroundColor = .blue
        customBackGroundView.translatesAutoresizingMaskIntoConstraints = false
        let height = UIApplication.shared.statusBarFrame.height
        guard let window = UIApplication.shared.keyWindow else {return}
        window.addSubview(customBackGroundView)
        customBackGroundView.anchorToView(top: window.topAnchor, leading: window.leadingAnchor, bottom: nil, trailing: window.trailingAnchor, padding: .zero, size: .init(width: 0, height: height))
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        customBackGroundView.removeFromSuperview()
    }
    private var popGesture: UIGestureRecognizer?
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        guard let nav = navigationController else {return}
        if nav.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) {
            self.popGesture = navigationController!.interactivePopGestureRecognizer
             self.navigationController!.view.removeGestureRecognizer(navigationController!.interactivePopGestureRecognizer!)
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
        let profileNav =  MainProfileController(collectionViewLayout:layout4)
        profileNav.tabBarItem.image = #imageLiteral(resourceName: "profile_selected").withRenderingMode(.alwaysOriginal)
        let recordImage =  UIViewController()
        recordImage.view.backgroundColor = .white
        recordImage.tabBarItem.image = #imageLiteral(resourceName: "microphone").withRenderingMode(.alwaysOriginal)
        viewControllers = [homeNav,searchNav,recordImage,notificationNav,profileNav]
    }
}
