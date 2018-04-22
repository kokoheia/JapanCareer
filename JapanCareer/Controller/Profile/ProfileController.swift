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

class ProfileController: UITableViewController {
    
    var isStudent: Bool?
    
    let headerId = "headerId"
    let descriptionId = "descriptionId"
    let footerId = "footerId"
    let userDescriptionHeaderId = "userDescriptionHeaderId"
    let headerWithButtonId = "headerWithButtonId"
    
    var studyCard = ProfileCard(type: .study)
    var internCard = ProfileCard(type: .intern)
    var skillCard = ProfileCard(type: .skill)
    var languageCard = ProfileCard(type: .language)
    
    lazy var studyCardList: [ProfileCard] = [studyCard]
    lazy var internCardList: [ProfileCard] = [internCard]
    lazy var skillCardList: [ProfileCard] = [skillCard]
    lazy var languageCardList: [ProfileCard] = [languageCard]
    
    
    lazy var cardsList = [studyCardList, internCardList, skillCardList, languageCardList]
    
//    var headerContentsList = ["", ""]
    var user: User?
    var subtitleDescription: String?
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
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
        
        
        navigationItem.title = "Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ChangeToStudent", style: .plain, target: self, action: #selector(handleChangeToStudent))
        
        checkUserType()
        setupBackground()
        fetchUser()
    }
    
    private func checkUserType() {
        if let rootTabBarC = UIApplication.shared.keyWindow?.rootViewController as? CustomTabBarController {
            isStudent = rootTabBarC.isStudent
        }
    }
    
    @objc private func handleChangeToStudent() {
        isStudent = !isStudent!
        tableView?.reloadData()
    }
    

    private func setupBackground() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bg-texture")
        tableView.backgroundView = imageView
    }

    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("uid or isstudent has been guarded")
            return
        }
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            
            self?.loadHeaderFromDatabase(ref: ref)
            self?.loadCardFromDatabase(ref: ref, type: .study)
            self?.loadCardFromDatabase(ref: ref, type: .intern)
            self?.loadCardFromDatabase(ref: ref, type: .skill)
            self?.loadCardFromDatabase(ref: ref, type: .language)
        }, withCancel: nil)
    }
    
    private func loadHeaderFromDatabase(ref: DatabaseReference) {
        ref.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let user = User(dictionary: dictionary)
                self?.user = user
//                self.headerContentsList[0] = name
//
//
//                if let name = dictionary["name"] as? String {
//                    self.headerContentsList[0] = name
//                }
//                if let url = dictionary["profileImageUrl"] as? String {
//
//                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    private func loadCardFromDatabase(ref: DatabaseReference, type: ProfileCardType) {
        let typeString = (type.rawValue).lowercased()
        let typeRef = ref.child(typeString)
        var newList: [ProfileCard] = []
        var isFirst = true
        typeRef.observe(.childAdded, with: { [weak self] (snapshot) in
            if let contentsDictionary =  snapshot.value as? [String: String] {
                
                //set a school name in the header
                if type == .study, isFirst {
                    isFirst = false
                    self?.subtitleDescription = contentsDictionary["title"]
//                    if let title = {
//
////                        self.headerContentsList[1] = title
//                    }
                }
                
                let card = ProfileCard(type: type)
                card.title = contentsDictionary["title"]
                card.detailTitle = contentsDictionary["subtitle"]
                card.startTime = contentsDictionary["startTime"]
                card.endTime = contentsDictionary["endTime"]
                
                
                newList.append(card)
                
                switch type {
                case .study:
                    self?.cardsList[0] = newList
                case .intern:
                    self?.cardsList[1] = newList
                case .skill:
                    self?.cardsList[2] = newList
                case .language:
                    self?.cardsList[3] = newList
                }
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
            let cardList = cardsList[section-1]
            return cardList.count + 2
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0  {
            return false
        }
        else if indexPath.section >= 1 {
            let cardList = cardsList[indexPath.section-1]
            if indexPath.row == 0 || indexPath.row == cardList.count + 1{
                return false
            }
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Couldn't get uid")
            return
        }
        
        var cardList = cardsList[indexPath.section-1]
        let card = cardList[indexPath.row-1]
        let typeString = (cardList[0].type!.rawValue).lowercased()
        let ref = Database.database().reference().child("users").child(uid).child(typeString)
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let cardInDatabase = ProfileCard(dictionary: dictionary)
//                print("this is a card info")
//                card.info()
//                print("this is a cardIndDatabase info")
//                cardInDatabase.info()
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
                            self?.cardsList[indexPath.section-1].remove(at: dIndex)
                            DispatchQueue.main.async{
                                tableView.reloadData()
                            }
                        }
                    }
                }
            }
//                let childKey = Array(dictionary)[indexPath.row-1].key
//                //                print(childKey)
//                let userRef = ref.child("\(childKey)")
//                userRef.removeValue { (err, ref) in
//                    if err != nil {
//                        print(err!)
//                        return
//                    }
//                    //                    print(self.cardsList[indexPath.section-1])
//                    self.cardsList[indexPath.section-1].remove(at: indexPath.row-1)
//                    DispatchQueue.main.async{
//                        tableView.reloadData()
//                    }
//                }
//            }
        }, withCancel: nil)
//        ref.observeSingleEvent(of: .value) { (snapshot) in
//
//        }
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
                cell.titleLabel.text = user?.name
                cell.subtitleLabel.text = subtitleDescription
                if let imageUrl = user?.profileImageUrl {
                    cell.profileImageView.loadImageWithCache(with: imageUrl)
                }
//                cell.titleLabel.text = headerContentsList[0]
//                cell.subtitleLabel.text = headerContentsList[1]
//                let ref = Database.database().reference().child("users").child(uid)
//                ref.observeSingleEvent(of: .value, with: { (snapshot) in
//                    if let dictinoary = snapshot.value as? [String: AnyObject] {
//                        if let name = dictinoary["name"] as? String  {
//                            cell.titleLabel.text = name
//                            cell.subtitleLabel.text = ""
//                        }
//                    }
//                }, withCancel: nil)
                
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: headerWithButtonId, for: indexPath) as! HeaderCellWithButton
                cell.messageButton.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
                return cell
            }
        } else {
            var cardList = cardsList[indexPath.section-1]

            if indexPath.row == 0 {
                let card = cardList[0]
                let cell = tableView.dequeueReusableCell(withIdentifier: userDescriptionHeaderId, for: indexPath) as! UserDescriptionHeaderCell
                cell.sectionNameLabel.text = card.type?.rawValue
                cell.editButton.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
                return cell
                
            } else if indexPath.row == cardList.count + 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: footerId, for: indexPath)
                return cell
            } else {
                let card = cardList[indexPath.row-1]
                let cell = tableView.dequeueReusableCell(withIdentifier: descriptionId, for: indexPath) as! UserDescriptionCell
                cell.titleLabel.text = card.title
                cell.detailLabel.text = card.detailTitle
                if let startTimeText = card.startTime, let endTimeText = card.endTime, startTimeText != "", endTimeText != ""  {
                    cell.timeLabel.text = "\(startTimeText)-\(endTimeText)"
                } else {
                    cell.timeLabel.text = ""
                }
                return cell
            }
        }
    }
    
    @objc private func handleEditHeader(_ sender: UIButton) {
        let editVC = EditViewController()
        if let headerCell = sender.superview as? HeaderTableViewCell {
            editVC.textInput.placeholder = headerCell.titleLabel.text
        }
        editVC.navigationItem.title = "Edit Name"
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    @objc private func handleSendMessage(_ sender: UIButton) {
        print(123)
    }
    
    @objc private func handleEdit(_ sender: UIButton) {
        let layout = UICollectionViewFlowLayout()
        let collectionVC = ProfileEditCollectionViewController(collectionViewLayout: layout)
        let cell = sender.superview as! UserDescriptionHeaderCell
        if let indexPath = tableView.indexPath(for: cell) {
            let cardList = cardsList[indexPath.section-1]
            collectionVC.cardList = cardList
            collectionVC.selectedIndex = indexPath.section-1
            collectionVC.currentEditingType = cardList[0].type
            collectionVC.isStudent = isStudent
            navigationController?.pushViewController(collectionVC, animated: true)
        }
//        
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
           let cardList = cardsList[indexPath.section-1]
            if indexPath.row == 0 || indexPath.row == cardList.count + 1 {
                    return 50
            }
            return 92
        }
    }
}



