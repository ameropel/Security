//
//  AppDelegate.swift
//  Security
//
//  Created by Mike Lepore on 5/24/17.
//  Copyright © 2017 Ameropel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navController: UINavigationController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.configureNavBar()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {

        self.displayLogin()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        self.displayLogin()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

        self.displayLogin()
    }
    
    
    // MARK: - Configure Nav Bar
    
    private func configureNavBar() {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if let window = self.window {
            
            self.navController = UINavigationController()
            self.navController.pushViewController(MainViewController(), animated: false)
            
            // Makes nav bar blurry
            self.navController.navigationBar.isTranslucent = false
            self.navController.view.backgroundColor = .clear
            
            self.navController.navigationBar.barTintColor = UIColor.secondaryColor
            
            // Nav bar button style
            self.navController.navigationBar.tintColor = UIColor.mainColor
            self.navController.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont.navBarFont]
            
            window.rootViewController = navController
            window.backgroundColor = UIColor.white
            window.makeKeyAndVisible()
        }
    }
    
    
    // MARK: - Lock Screen
    
    private func displayLogin() {
        
        return
        
        // If login screen is already presented dont do anything
        guard !(self.navController.visibleViewController is SecureLoginViewController) else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            
            // Dismis previous view controller first
            self.navController.dismiss(animated: false, completion: nil)
            
            let login = SecureLoginViewController()
            login.modalPresentationStyle = .custom
            self.navController?.present(login, animated: false, completion: nil)
        })
    }
}

