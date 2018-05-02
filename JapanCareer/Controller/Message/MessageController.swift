//
//  ViewController.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/03/29.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit
import Firebase

class MessageController: UITableViewController {
    
    var isStudent: Bool?
    var cellId = "cellId"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorColor = .clear
        checkIfUserLoggedIn()
        observeUserMessage()
        
    }
    
    private func setupNavigationItem() {
        navigationItem.title = "Message"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
    }
    
    var messages = [Message]()
    var messageDictionary  = [String : Message]()
    
    private func observeUserMessage() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
       
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let userId = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                let messageRef = Database.database().reference().child("messages").child(messageId)
                messageRef.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let message = Message(dictionary: dictionary)
                        if let chatPartnerId = message.chatPartnerId() {
                            self?.messageDictionary[chatPartnerId] = message
                        }
                        self?.attemptReloadOfTable()
                    }
                    }, withCancel: nil)
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    private func attemptReloadOfTable() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self as Any, selector: #selector(handleReloadTable), userInfo: nil, repeats: false)
    }
    
    @objc private func handleReloadTable() {
        messages = Array(messageDictionary.values)
        messages.sort(by: { (m1, m2) -> Bool in
            if let timeInt1 = m1.timestamp?.intValue, let timeInt2 = m2.timestamp?.intValue {
                return timeInt1 > timeInt2
            }
            return true
        })

        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    var timer: Timer?
    
    
    @objc func showChatLogController(user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    @objc private func handleNewMessage() {
        let nmController = NewMessageController()
        nmController.messageController = self
        nmController.isStudent = isStudent
//        navigationController?.pushViewController(nmController, animated: true)
        let navController = UINavigationController(rootViewController: nmController)
        present(navController, animated: true, completion: nil)
    }
    
    private func checkIfUserLoggedIn() {
        if let uid = Auth.auth().currentUser?.uid {
            fetchUserAndSetUpNavBarTitle()
            checkIfUserStudentOrCompany(with: uid)
        } else {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    
    private func checkIfUserStudentOrCompany(with uid: String) {
        //check if the user is student
        let studentRef = Database.database().reference().child("users").child("student")
        studentRef.observe(.childAdded, with: { [weak self] (snapshot) in
            if snapshot.key == uid {
                if let rootTabBarC = UIApplication.shared.keyWindow?.rootViewController as? CustomTabBarController {
                    rootTabBarC.isStudent = true
                    return
                }
            }
        }, withCancel: nil)
        
        //check if the user is company
        let companyRef = Database.database().reference().child("users").child("company")
        companyRef.observe(.childAdded, with: { [weak self] (snapshot) in
            print(snapshot)
            if snapshot.key == uid {
                if let rootTabBarC = UIApplication.shared.keyWindow?.rootViewController as? CustomTabBarController {
                    rootTabBarC.isStudent = false
                }
            }
        }, withCancel: nil)
    }
    
    func fetchUserAndSetUpNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid, let isstudent = isStudent else {
            print("couldn't get it")
            return
        }
        
        var ref = DatabaseReference()
        if isstudent {
            ref = Database.database().reference().child("users").child("student").child(uid)
            ref.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                if let dictionary = snapshot.value as? [String : AnyObject]  {
                    self?.navigationItem.title = dictionary["name"] as? String
                }
            })
        } else {
            ref = Database.database().reference().child("users").child("company").child(uid)
            ref.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                if let dictionary = snapshot.value as? [String : AnyObject]  {
                    self?.navigationItem.title = dictionary["name"] as? String
                }
            })
        }
    }
    
    
    @objc private func handleLogout(){
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
            return
        }
        
        let loginVC = RegisterController()
        loginVC.messageController = self
        present(loginVC, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! UserCell
        cell.isStudent = isStudent

        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        if let userId = message.chatPartnerId() {
            
            let userType = isStudent! ? "company" : "student"
            
            let ref = Database.database().reference().child("users").child(userType).child(userId)
            ref.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let user = User(dictionary: dictionary)
                    user.id = userId
                    self?.showChatLogController(user: user)
                }
            }, withCancel: nil)
        }
    }
}


