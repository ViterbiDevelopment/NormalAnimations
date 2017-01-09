//
//  AppDelegate.swift
//  NormalAnimations
//
//  Created by 掌上先机 on 17/1/6.
//  Copyright © 2017年 wangchao. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        
        let vc = ViewController()
        
        let nav = UINavigationController.init(rootViewController: vc)
        
        window?.rootViewController = nav
        

        window?.makeKeyAndVisible()
        
        return true
    }

   

}

