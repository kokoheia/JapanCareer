//
//  NewMessageControllerTableViewController.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/03/31.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit
import Firebase

final class NewMessageController: UITableViewController {
    
    var isStudent: Bool?
    
    private var users = [User]()
    private var cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        tabBarController?.tabBar.isHidden = false
        fetchUser()

    }

    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    private func fetchUser() {
        let userType = isStudent! ? "company" : "student"
        
        let ref = Database.database().reference().child("users").child(userType)
        ref.observe(.childAdded, with: { [weak self] (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let user = User(dictionary: dictionary)
                user.id = snapshot.key
                self?.users.append(user)
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageWithCache(with: profileImageUrl)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    var messageController : MessageController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) { [weak self] in
            let user = self?.users[indexPath.row]
            self?.messageController?.showChatLogController(user: user!)
        }
    }
}

