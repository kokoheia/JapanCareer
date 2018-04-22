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

        var sectionIndicator =  ""
        if let sectionTitle = cardList[0].type {
            switch sectionTitle {
            case .study:
                sectionIndicator = "study"
            case .intern:
                sectionIndicator = "intern"
            case .language:
                sectionIndicator = "language"
            case .skill:
                sectionIndicator = "skill"
            }
        }
        
        let rootController = navigationController?.viewControllers.first as! ProfileController
        let type = ((cardList[0].type?.rawValue)!).lowercased()
        let userRef = Database.database().reference().child("users").child(uid).child(type)
        for i in 0..<cardList.count {
            if cardList[i].title != nil || cardList[i].detailTitle != nil || cardList[i].startTime != nil || cardList[i].endTime != nil {
                let childRef = userRef.child("\(type)\(i)")
                let values = [
                    "title" : cardList[i].title ?? "",
                    "subtitle" : cardList[i].detailTitle ?? "",
                    "startTime" : cardList[i].startTime ?? "",
                    "endTime" : cardList[i].endTime ?? ""
                ]
                
                childRef.updateChildValues(values) { [weak self] (err, ref) in
                    if err != nil {
                        print(err!)
                        return
                    }
                    if let cList = self?.cardList, let index = self?.selectedIndex  {
                        rootController.cardsList[index] = cList
                        DispatchQueue.main.async {
                            rootController.tableView.reloadData()
                            self?.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            } else {
                cardList.remove(at: i)
                print("at least one element should be filled")
                rootController.cardsList[selectedIndex!] = cardList
                rootController.tableView.reloadData()
                navigationController?.popViewController(animated: true)
                
            }
            
           
        }

       
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cardList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.bounds.width, height: 40)
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
        let editVC = EditViewController()
        let card = cardList[indexPath.section]
        let title = card.editTitles()[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath) as! UserDescriptionCollectionViewCell
        let contentList = makeContentList(cell: cell, card: card)
        let contentText = contentList[indexPath.row]

//        editVC.navigationController?.title = title
        editVC.textInput.placeholder = contentText
        editVC.currentCard = card
        editVC.currentRowNumber = indexPath.row
        navigationController?.pushViewController(editVC, animated: true)
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
            if let startTime = card.startTime {
                contentList.append(startTime)
            } else {
                contentList.append("")
            }
            if let endTime = card.endTime {
                contentList.append(endTime)
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
            if let startTime = card.startTime {
                contentList.append(startTime)
            } else {
                contentList.append("")
            }
            if let endTime = card.endTime {
                contentList.append(endTime)
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
