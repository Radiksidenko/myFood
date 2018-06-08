//
//  AppDelegate.swift
//  myFood
//
//  Created by Radomyr Sidenko on 06.06.2018.
//  Copyright © 2018 Radomyr Sidenko. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

   
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = "266219949571-op2k7bjruurv6k5gj9roqcccsqh3eal4.apps.googleusercontent.com"
        let defaults = UserDefaults.standard
        let defaultValue = ["login":"","name":""]
        defaults.register(defaults: defaultValue)
       
         print("/////",UserDefaults.standard.string(forKey: "login"),"\t",UserDefaults.standard.string(forKey: "name"),"/////")
        if(UserDefaults.standard.string(forKey: "login") != "login"){
            let appDeligate = UIApplication.shared.delegate as? AppDelegate
            let main = UIStoryboard(name: "Login", bundle: Bundle.main).instantiateInitialViewController()
            appDeligate?.window?.rootViewController = main
        }
       
        
        return true
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
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


}

