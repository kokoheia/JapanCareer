//
//  CustomTabBarController.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/04.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit
import Firebase

final class CustomTabBarController: UITabBarController {
    
    var isStudent: Bool?
    
    private func checkIfUserLoggedIn() {
        if let uid = Auth.auth().currentUser?.uid {
            checkIfUserStudentOrCompany(with: uid)
        } else {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    
    private func checkIfUserStudentOrCompany(with uid: String ) {
        //check if the user is student
        let studentRef = Database.database().reference().child("users").child("student")
        studentRef.observe(.childAdded, with: { [weak self] (snapshot) in
            if snapshot.key == uid {
                self?.isStudent = true
                self?.setUpViewControllers()
                
            }
            }, withCancel: nil)
        
        //check if the user is company
        let companyRef = Database.database().reference().child("users").child("company")
        companyRef.observe(.childAdded, with: { [weak self] (snapshot) in
            if snapshot.key == uid {
                self?.isStudent = false
                self?.setUpViewControllers()
            }
        }, withCancel: nil)
        
        
    }
    
    @objc private func handleLogout(){
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
            return
        }
        
        let loginVC = RegisterController()
        present(loginVC, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewControllers = [UIViewController(), UIViewController(),  UIViewController()]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserLoggedIn()
        
    }
    
    private func setUpViewControllers() {
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
        
        var profileNavigationController = UINavigationController()
        
        if isStudent! {
            let pc = ProfileController()
            pc.isStudent = isStudent
            profileNavigationController = UINavigationController(rootViewController: pc)
        } else {
            let pc = CompanyProfileViewController()
            pc.isStudent = isStudent
            profileNavigationController = UINavigationController(rootViewController: pc)
        }

        profileNavigationController.tabBarItem.title = "Profile"
        profileNavigationController.tabBarItem.image = UIImage(named: "profile")
        
        viewControllers = [messageNavigationController, listNavigationController,  profileNavigationController]
    }
    
    func refreshUser() {
        if let messageNavigationController = viewControllers![0] as? UINavigationController {
            if let messageController = messageNavigationController.viewControllers[0] as? MessageController{
                messageController.checkIfUserLoggedIn()
                messageController.observeUserMessage()
            }
        }
        
        if let listNavigationController = viewControllers![1] as? UINavigationController {
            if let listController = listNavigationController.viewControllers[0] as? ListViewController {
                listController.fetchCompanies()
                listController.fetchStudents()
            }
        }
        
        if let profileNavigationController =  viewControllers![2] as? UINavigationController {
            if let profileController = profileNavigationController.viewControllers[0] as? ProfileController {
                profileController.fetchUser()
            } else if let profileController = profileNavigationController.viewControllers[0] as? CompanyProfileViewController {
                profileController.fetchCompanyData()
            }
        }
    }

}
