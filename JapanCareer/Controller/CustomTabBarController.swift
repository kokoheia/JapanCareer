//
//  CustomTabBarController.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/04.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listNavigationController = UINavigationController(rootViewController: ListViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        listNavigationController.tabBarItem.title = "Search"
        listNavigationController.tabBarItem.image = UIImage(named: "search")
        

        let messageNavigationController = UINavigationController(rootViewController: MessageController())
        messageNavigationController.tabBarItem.title = "Message"
        messageNavigationController.tabBarItem.image = UIImage(named: "message")
        
        
        let profileNavigationController = UINavigationController(rootViewController: ProfileController())
        profileNavigationController.tabBarItem.title = "Profile"
        profileNavigationController.tabBarItem.image = UIImage(named: "profile")

        viewControllers = [listNavigationController, messageNavigationController, profileNavigationController]

        
    }
}
