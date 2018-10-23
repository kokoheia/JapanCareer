//
//  ProfileController.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/04.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit
import Firebase

let cardCornerRadius: CGFloat = 20

class ProfileController: UITableViewController, TableDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let headerId = "headerId"
    let descriptionId = "descriptionId"
    let footerId = "footerId"
    let userDescriptionHeaderId = "userDescriptionHeaderId"
    let headerWithButtonId = "headerWithButtonId"
    
    var isStudent: Bool?
    var user: User?
    var subtitleDescription: String?
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ProfileCardType.allCases.count + 1
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(HeaderTableViewCell.self, forCellReuseIdentifier: headerId)
        tableView.register(UserDescriptionCell.self, forCellReuseIdentifier: descriptionId)
        tableView.register(FooterTableViewCell.self, forCellReuseIdentifier: footerId)
        tableView.register(UserDescriptionHeaderCell.self, forCellReuseIdentifier: userDescriptionHeaderId)
        tableView.register(HeaderCellWithButton.self, forCellReuseIdentifier: headerWithButtonId)
        tableView.separatorStyle = .none
        
        if isStudent! {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        }

        navigationItem.title = "Profile"
        checkUserType()
        setupBackground()
        fetchUser()
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

    func handleSetupProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        var selectedImage : UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImage = editedImage
        } else {
            selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        }
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        if let profileImage = selectedImage, let imageData = UIImageJPEGRepresentation(profileImage, 0.1) {
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile-images").child("\(imageName).jpg")
            storageRef.putData(imageData, metadata: nil, completion: { [weak self] (metadata, err) in
                
                if err != nil {
                    print(err!)
                    return
                }
                
                if let imageUrlString = metadata?.downloadURL()?.absoluteString {
                    let values = ["profileImageUrl": imageUrlString]
                    self?.user?.profileImageUrl = imageUrlString
                    
                    let ref = Database.database().reference().child("users").child("student").child(uid)
                    ref.updateChildValues(values)
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            })
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func handleSetupHeaderImage() {
        return
    }
    
    private func checkUserType() {
        if isStudent == nil {
            if let rootTabBarC = UIApplication.shared.keyWindow?.rootViewController as? CustomTabBarController {
                isStudent = rootTabBarC.isStudent
            }
        }
    }
    private func setupBackground() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bg-texture")
        tableView.backgroundView = imageView
    }

    func fetchUser() {
        if user == nil {
            guard let uid = user?.id ?? Auth.auth().currentUser?.uid  else {
                return
            }
            
            let userType = self.isStudent! ? "student" : "company"
            let ref = Database.database().reference().child("users").child(userType).child(uid)
            
            ref.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                if let dictionary = snapshot.value as? Dictionary<String, AnyObject> {
                    self?.user = User(dictionary: dictionary)
                    self?.user?.sortCardLists()
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }, withCancel: nil)
        }
    }
    
    private func loadHeaderFromDatabase(ref: DatabaseReference) {
        ref.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let user = User(dictionary: dictionary)
                user.id = snapshot.key
                self?.user = user
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if let cardList = user?.cardList[section-1] {
                return cardList.count + 2
            }
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0  {
            return false
        }
        else if indexPath.section >= 1 {
            if let cardList = user?.cardList[indexPath.section-1] {
                if indexPath.row == 0 || indexPath.row == cardList.count + 1{
                    return false
                }
            }
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Couldn't get uid")
            return
        }
        
        if var cardList = user?.cardList[indexPath.section-1] {
            let card = cardList[indexPath.row-1]
            let type = cardList[0].type!
            let typeString = (type.rawValue).lowercased()
            let userType = self.isStudent! ? "student" : "company"
            let ref = Database.database().reference().child("users").child(userType).child(uid).child(typeString)
            ref.observe(.childAdded, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let cardInDatabase = ProfileCard(dictionary: dictionary, type: type)
                    if cardInDatabase == card {
                        let childKey = snapshot.key
                        let userRef = ref.child("\(childKey)")
                        userRef.removeValue { [weak self] (err, ref) in
                            if err != nil {
                                print(err!)
                                return
                            }
                            var deleteIndex: Int?
                            for index in cardList.indices {
                                let cardInList = cardList[index]
                                if cardInList == card {
                                    deleteIndex = index
                                }
                            }
                            if let dIndex = deleteIndex {
                                self?.user?.cardList[indexPath.section-1].remove(at: dIndex)
                                DispatchQueue.main.async{
                                    tableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }, withCancel: nil)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let uid = Auth.auth().currentUser?.uid, let isstudnet = isStudent else {
            print("uid or isstudent has been guarded")
            return UITableViewCell()
        }
        
        if indexPath.section == 0 {
            if isstudnet {
                let cell = tableView.dequeueReusableCell(withIdentifier: headerId, for: indexPath) as! HeaderTableViewCell
                cell.editButton.addTarget(self, action: #selector(handleEditHeader), for: .touchUpInside)
                cell.editButton.isUserInteractionEnabled = isStudent! ? true : false
                cell.editButton.isHidden = isStudent! ? false : true
                cell.profileImageView.isUserInteractionEnabled = isStudent! ? true : false
                cell.titleLabel.text = user?.name
                cell.subtitleLabel.text = user?.studyList[0].title
                cell.delegate = self
                
                if let imageUrl = user?.profileImageUrl {
                    cell.profileImageView.loadImageWithCache(with: imageUrl)
                }
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: headerWithButtonId, for: indexPath) as! HeaderCellWithButton
                cell.messageButton.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
                cell.titleLabel.text = user?.name
                cell.subtitleLabel.text = user?.studyList[0].title
                
                if let imageUrl = user?.profileImageUrl {
                    cell.profileImageView.loadImageWithCache(with: imageUrl)
                }
                return cell
            }
        } else {
            if var cardList = user?.cardList[indexPath.section-1] {
                if indexPath.row == 0 {
                    let card = cardList[0]
                    let cell = tableView.dequeueReusableCell(withIdentifier: userDescriptionHeaderId, for: indexPath) as! UserDescriptionHeaderCell
                    cell.sectionNameLabel.text = card.type?.rawValue
                    cell.editButton.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
                    cell.editButton.isUserInteractionEnabled = isStudent! ? true : false
                    cell.editButton.isHidden = isStudent! ? false : true
                    
                    return cell
                    
                } else if indexPath.row == cardList.count + 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: footerId, for: indexPath)
                    return cell
                } else {
                    let card = cardList[indexPath.row-1]
                    let cell = tableView.dequeueReusableCell(withIdentifier: descriptionId, for: indexPath) as! UserDescriptionCell
                    cell.titleLabel.text = card.title
                    cell.detailLabel.text = card.detailTitle
                    
                    if let startTime = card.startTimestamp, let endTime = card.endTimestamp {
                        let startTimeText = startTime.transformToText(with: "YYYY.M")
                        let endTimeText = endTime.transformToText(with: "YYYY.M")
                        cell.timeLabel.text = "\(startTimeText)-\(endTimeText)"
                    } else {
                        cell.timeLabel.text = ""
                    }
                    return cell
                }
            }
            return UITableViewCell()
        }
    }
    
    @objc private func handleEditHeader(_ sender: UIButton) {
        let editVC = EditViewController()
        if let headerCell = sender.superview as? HeaderTableViewCell {
            editVC.textInput.placeholder = headerCell.titleLabel.text
        }
        editVC.isStudent = isStudent
        editVC.navigationItem.title = "Edit Name"
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    @objc private func handleSendMessage(_ sender: UIButton) {
        let layout = UICollectionViewFlowLayout()
        let chatLogVC = ChatLogController(collectionViewLayout: layout)
        chatLogVC.user = user
        navigationController?.pushViewController(chatLogVC, animated: true)
    }
    
    @objc private func handleEdit(_ sender: UIButton) {
        let layout = UICollectionViewFlowLayout()
        let collectionVC = ProfileEditCollectionViewController(collectionViewLayout: layout)
        let cell = sender.superview as! UserDescriptionHeaderCell
        if let indexPath = tableView.indexPath(for: cell) {
            if let cardList = user?.cardList[indexPath.section-1] {
                collectionVC.cardList = cardList
                collectionVC.selectedIndex = indexPath.section-1
                collectionVC.currentEditingType = cardList[0].type
                collectionVC.isStudent = isStudent
                navigationController?.pushViewController(collectionVC, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 5 {
            if let link = user?.linkList[indexPath.row-1].detailTitle {
                openUrl(urlStr: link)
            }
        }
    }
    
    private func openUrl(urlStr: String) {
        if let url = URL(string: urlStr)  {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let isstudent = isStudent else {
            return 100
        }
        
        if indexPath.section == 0 {
            if isstudent {
                return 235
            }
            return 275
        } else {
            if let cardList = user?.cardList[indexPath.section-1] {
                if indexPath.row == 0 || indexPath.row == cardList.count + 1 {
                    return 50
                }
            }
            return 92
        }
    }
}

extension NSNumber {
    func transformToText(with format: String) -> String {
            let seconds = self.doubleValue
            let date = Date(timeIntervalSince1970: seconds)
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = format
            
            let elapsedTimeInSeconds = NSDate().timeIntervalSince(date)
            
            let secondsInDays: TimeInterval = 60 * 60 * 24
            
            return dateFormatter.string(from: date)
            
//            timeLabel.text = dateFormatter.string(from: date)
    }
    
    func transformToDate() -> Date {
        let seconds = self.doubleValue
        return Date(timeIntervalSince1970: seconds)
    }
}



