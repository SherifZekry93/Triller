//
//  AppDelegate.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/13/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import MOLH
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate,UNUserNotificationCenterDelegate, MOLHResetable{
    func reset() {
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        let stry = UIStoryboard(name: "Main", bundle: nil)
        rootviewcontroller.rootViewController = stry.instantiateViewController(withIdentifier: "rootnav")
        
    }
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        MOLH.shared.activate(true)
       /* // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        //let layout = UICollectionViewFlowLayout()
        if Auth.auth().currentUser != nil
        {
           // let homeFeed = CompleteSignUp()
          //  window?.rootViewController = homeFeed
            //actual code
            let homeFeed = MainTabBarController()
            window?.rootViewController = UINavigationController(rootViewController:   homeFeed)
        }
        else
        {
        let loginController = UINavigationController(rootViewController:   LoginController())
            window?.rootViewController =  loginController
        }*/
        //attemptRegisterForNotification(with:application)
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken)
    }
    
    //listen for user notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("here is the token",fcmToken)
    }
    private func attemptRegisterForNotification(with application:UIApplication)
    {
        Messaging.messaging().delegate = self
        let options:UNAuthorizationOptions = [.alert,.badge,.sound]
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, error) in
            if let err = error
            {
                print(err)
                return
            }
            else if granted
            {
                print(granted)
            }
        }
        application.registerForRemoteNotifications()
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Messaging.messaging().sendMessage(<#T##message: [AnyHashable : Any]##[AnyHashable : Any]#>, to: <#T##String#>, withMessageID: <#T##String#>, timeToLive: <#T##Int64#>)
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

