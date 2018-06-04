//
//  ProfileEditCollectionViewController.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/12.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit
import Firebase

class ProfileEditCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var isStudent: Bool?
    
    var cardList = [ProfileCard]()
    var currentEditingType: ProfileCardType?
    var selectedIndex: Int?
    lazy var originalCardList = cardList
    
    private let descriptionViewId = "descriptionViewId"
    private let descriptionViewHeaderId = "descriptionViewHeaderId"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        collectionView?.register(UserDescriptionCollectionViewCell.self, forCellWithReuseIdentifier: descriptionViewId)
        collectionView?.register(EditCollectionViewHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: descriptionViewHeaderId)
        collectionView?.backgroundColor = .white
    }
    
    private func setupNavigationBar() {
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        let saveBarButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        navigationItem.rightBarButtonItems = [saveBarButton, addBarButton]
        navigationItem.title = "Edit \(currentEditingType!.rawValue)"
    }
    
    @objc private func handleAdd() {
        let newCard = ProfileCard(type: currentEditingType!)
        if !cardList.contains(newCard) {
            cardList.append(newCard)
            collectionView?.reloadData()
            let section = cardList.count-1
            let indexPath = IndexPath(item: 0, section: section)
            collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.top, animated: true)
        } else {
            print("You can make only one placeholder")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc private func handleSave() {
        guard let uid = Auth.auth().currentUser?.uid, let isstudnet = isStudent else {
            print("guard has been activated")
            return
        }

//        var sectionIndicator =  ""
//        if let sectionTitle = cardList[0].type {
//            switch sectionTitle {
//            case .study:
//                sectionIndicator = "study"
//            case .intern:
//                sectionIndicator = "intern"
//            case .language:
//                sectionIndicator = "language"
//            case .skill:
//                sectionIndicator = "skill"
//            case .link:
//                sectionIndicator = "link"
//            }
//        }
        
        let rootController = navigationController?.viewControllers.first as! ProfileController
        let type = ((cardList[0].type?.rawValue)!).lowercased()
        let userType = self.isStudent! ? "student" : "company"
        let userRef = Database.database().reference().child("users").child(userType).child(uid).child(type)
        for i in 0..<cardList.count {
            if cardList[i].title != nil || cardList[i].detailTitle != nil || cardList[i].startTimestamp != nil || cardList[i].endTimestamp != nil {
                let childRef = userRef.child("\(type)\(i)")
                var values: [String: Any] = [:]
                
                if let startTime = cardList[i].startTimestamp, let endTime = cardList[i].endTimestamp {
                    values  = [
                        "title" : cardList[i].title ?? "",
                        "subtitle" : cardList[i].detailTitle ?? "",
                        "startTime" : Int(truncating: startTime),
                        "endTime" : Int(truncating: endTime)
                    ]
                } else {
                    values  = [
                        "title" : cardList[i].title ?? "",
                        "subtitle" : cardList[i].detailTitle ?? ""
                    ]
                }
 
                childRef.updateChildValues(values) { [weak self] (err, ref) in
                    if err != nil {
                        print(err!)
                        return
                    }
                    if let cList = self?.cardList, let index = self?.selectedIndex  {
                        rootController.user?.cardList[index] = cList
                        rootController.user?.sortCardLists()
                        DispatchQueue.main.async {
                            rootController.tableView.reloadData()
                            self?.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            } else {
                cardList.remove(at: i)
                print("at least one element should be filled")
                rootController.user?.cardList[selectedIndex!] = cardList
                rootController.tableView.reloadData()
                navigationController?.popViewController(animated: true)
                
            }
            
           
        }

       
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cardList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.bounds.width, height: 56)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardList[0].editTitles().count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptionViewId, for: indexPath) as! UserDescriptionCollectionViewCell
        let card = cardList[indexPath.section]
        let contentList = makeContentList(cell: cell, card: card)
        cell.titleLabel.text = card.editTitles()[indexPath.row]
        cell.textLabel.text = contentList[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 2 || indexPath.row == 3 {
            let editVC = EditDateViewController()
            let selectedCard = cardList[indexPath.section]
            editVC.currentCard = selectedCard
            editVC.currentRowNumber = indexPath.row
            editVC.startTimestamp = selectedCard.startTimestamp
            editVC.endTimestamp = selectedCard.endTimestamp
            if indexPath.row == 2 {
                editVC.textInput.placeholder = selectedCard.startTimestamp?.transformToText(with: "YYYY.M.d")
            } else {
                editVC.textInput.placeholder = selectedCard.endTimestamp?.transformToText(with: "YYYY.M.d")
            }
            navigationController?.pushViewController(editVC, animated: true)
            return 
        }
        
        let editVC = EditViewController()
        let card = cardList[indexPath.section]
        let title = card.editTitles()[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath) as! UserDescriptionCollectionViewCell
        let contentList = makeContentList(cell: cell, card: card)
        let contentText = contentList[indexPath.row]

//        editVC.navigationController?.title = title
        if let type = card.type {
            editVC.textInput.placeholder = placeHolderMaker(with: indexPath.row, type: type)
        }
        editVC.currentCard = card
        editVC.currentRowNumber = indexPath.row
        editVC.isStudent = self.isStudent
        editVC.currentTitle = title
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    private func placeHolderMaker(with itemNumber: Int, type: ProfileCardType) -> String{
        switch itemNumber {
        case 0:
            switch type {
            case .study:
                return "ex. Carnegie Mellon University"
            case .intern:
                return "ex. Apple"
            case .language:
                return "ex. English"
            case .skill:
                return "ex. Swift"
            case .link:
                return "ex. GitHub"
            }
        case 1:
            switch type {
            case  .study:
                return "ex. School of Computer Science"
            case .intern:
                return "ex. Software Engineer"
            case .language:
                return "ex. Native"
            case .skill:
                return "ex. 3 years experience..."
            case .link:
                return "ex. Enter your link here..."
            }
        case 2:
            return "ex. 2017.5"
        case 3:
            return "ex. 2017.8"
        default:
            return "Enter text..."
        }
        
    }
    
    
    private func makeContentList(cell: UserDescriptionCollectionViewCell, card: ProfileCard) -> [String] {
        var contentList = [String]()
        switch card.type! {
        case .study:
            if let title = card.title {
                contentList.append(title)
            } else {
                contentList.append("")
            }
            if let detail = card.detailTitle {
                contentList.append(detail)
            } else {
                contentList.append("")
            }
            if let startTime = card.startTimestamp {
                contentList.append(startTime.transformToText(with: "YYYY.M.d"))
            } else {
                contentList.append("")
            }
            if let endTime = card.endTimestamp {
                contentList.append(endTime.transformToText(with: "YYYY.M.d"))
            } else {
                contentList.append("")
            }
            return contentList
            
        case .intern:
            if let title = card.title {
                contentList.append(title)
            } else {
                contentList.append("")
            }
            if let detail = card.detailTitle {
                contentList.append(detail)
            } else {
                contentList.append("")
            }
            if let startTime = card.startTimestamp {
                contentList.append(startTime.transformToText(with: "YYYY.M.d"))
            } else {
                contentList.append("")
            }
            if let endTime = card.endTimestamp {
                contentList.append(endTime.transformToText(with: "YYYY.M.d"))
            } else {
                contentList.append("")
            }
            return contentList
            
        case .skill:
            if let title = card.title {
                contentList.append(title)
            } else {
                contentList.append("")
            }
            if let detail = card.detailTitle {
                contentList.append(detail)
            } else {
                contentList.append("")
            }
            return contentList
            
        case .language:
            if let title = card.title {
                contentList.append(title)
            } else {
                contentList.append("")
            }
            if let detail = card.detailTitle {
                contentList.append(detail)
            } else {
                contentList.append("")
            }
            return contentList
        case .link:
            if let title = card.title {
                contentList.append(title)
            } else {
                contentList.append("")
            }
            if let detail = card.detailTitle {
                contentList.append(detail)
            } else {
                contentList.append("")
            }
            return contentList
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: descriptionViewHeaderId, for: indexPath) as! EditCollectionViewHeaderCell
        if let title = cardList[0].type?.rawValue {
             headerView.titleLabel.text = "\(title) \(indexPath.section+1)"
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 77)
    }
    
}

