//
//  AppDelegate.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/12.
//  Copyright © 2018 com.js. All rights reserved.
//

import UIKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        let userManager:UserManager = UserManager.shared
        //userManager.logout()
        if !userManager.isUserLogin {
            window = UIWindow(frame: UIScreen.main.bounds)
            let loginStoryboard:UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            if let loginVC = loginStoryboard.instantiateViewController(withIdentifier: "MBLoginViewController") as? MBLoginViewController {
                self.window?.rootViewController = loginVC
                window?.makeKeyAndVisible()
            }
        } else {
            userManager.login()
        }
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
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
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handle = FBSDKApplicationDelegate.sharedInstance()?.application(app, open: url, options: options)
        if UserManager.shared.isUserLogin {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if let mainVC = mainStoryboard.instantiateViewController(withIdentifier: "mainNavigation") as? UINavigationController {
                self.window?.rootViewController = mainVC
                window?.makeKeyAndVisible()
            }
        }
        return handle ?? true
    }
}

