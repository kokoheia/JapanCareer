//
//  CustomTabBarController.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/04.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    var isStudent: Bool?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let lvc = ListViewController(collectionViewLayout: UICollectionViewFlowLayout())
        lvc.isStudent = isStudent
        let listNavigationController = UINavigationController(rootViewController: lvc)
        listNavigationController.tabBarItem.title = "Search"
        listNavigationController.tabBarItem.image = UIImage(named: "search")
        
        
        let mc = MessageController()
        mc.isStudent = isStudent
        let messageNavigationController = UINavigationController(rootViewController: mc)
        messageNavigationController.tabBarItem.title = "Message"
        messageNavigationController.tabBarItem.image = UIImage(named: "message")
        
        
        let pc = ProfileController()
        pc.isStudent = isStudent
        let profileNavigationController = UINavigationController(rootViewController: pc)
        profileNavigationController.tabBarItem.title = "Profile"
        profileNavigationController.tabBarItem.image = UIImage(named: "profile")
        
        viewControllers = [messageNavigationController, listNavigationController,  profileNavigationController]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("isStudent of custom tab bar controller is \(isStudent)")
//
//        let listNavigationController = UINavigationController(rootViewController: ListViewController(collectionViewLayout: UICollectionViewFlowLayout()))
//        listNavigationController.tabBarItem.title = "Search"
//        listNavigationController.tabBarItem.image = UIImage(named: "search")
//
//
//        let messageNC = MessageController()
//        messageNC.isStudent = isStudent
//        let messageNavigationController = UINavigationController(rootViewController: messageNC)
//        messageNavigationController.tabBarItem.title = "Message"
//        messageNavigationController.tabBarItem.image = UIImage(named: "message")
//
//
//        let profileNavigationController = UINavigationController(rootViewController: ProfileController())
//        profileNavigationController.tabBarItem.title = "Profile"
//        profileNavigationController.tabBarItem.image = UIImage(named: "profile")
//
//        viewControllers = [messageNavigationController, listNavigationController,  profileNavigationController]

        
    }
}
