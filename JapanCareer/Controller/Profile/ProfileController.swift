//
//  ProfileController.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/04.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

let cardCornerRadius: CGFloat = 20

class ProfileController: UITableViewController {
    
    let headerId = "headerId"
    let descriptionId = "descriptionId"
    let footerId = "footerId"
    let userDescriptionHeaderId = "userDescriptionHeaderId"
    
    var studyCard1 = ProfileCard(type: .study)
    var studyCard2 = ProfileCard(type: .study)
    var internCard1 = ProfileCard(type: .intern)
    var internCard2 = ProfileCard(type: .intern)
    var skillCard1 = ProfileCard(type: .skill)
    var skillCard2 = ProfileCard(type: .skill)
    var skillCard3 = ProfileCard(type: .skill)
    var languageCard1 = ProfileCard(type: .language)
    var languageCard2 = ProfileCard(type: .language)
    
    lazy var studyCardList = [studyCard1, studyCard2]
    lazy var internCardList = [internCard1, internCard2]
    lazy var skillCardList = [skillCard1, skillCard2, skillCard3]
    lazy var languageCardList = [languageCard1, languageCard2]
    
    lazy var cardsList = [studyCardList, internCardList, skillCardList, languageCardList]
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
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
        tableView.separatorStyle = .none
        
        navigationItem.title = "Profile"
        
        setupBackground()
        fetchUser()
    }
    

    private func setupBackground() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bg-texture")
        tableView.backgroundView = imageView
    }

    private func fetchUser() {
        studyCard1.title = "Carnegie Mellon University"
        studyCard1.detailTitle = "Computer Science Department"
        studyCard1.startTime = "2017.5"
        studyCard1.endTime = "2018.9"
        
        studyCard2.title = "Keio University"
        studyCard2.detailTitle = "Business and Commerse Department"
        studyCard2.startTime = "2015.4"
        studyCard2.endTime = "2019.3"
        
        internCard1.title = "ABEJA"
        internCard1.detailTitle = "Data Engineer"
        internCard1.startTime = "2017.12"
        internCard1.endTime = "2018.1"
        
        internCard2.title = "DeNA"
        internCard2.detailTitle = "HR internship"
        internCard2.startTime = "2017.5"
        internCard2.endTime = "2018.9"
        
        skillCard1.title = "Swift"
        skillCard1.detailTitle = "3 month"
        
        skillCard2.title = "UI/UX Design"
        skillCard2.detailTitle = "3 month"
        
        skillCard3.title = "Photography"
        skillCard3.detailTitle = "3 years"
        
        languageCard1.title = "Japanese"
        languageCard1.detailTitle = "Native"
        
        languageCard2.title = "English"
        languageCard2.detailTitle = "Business"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            let cardList = cardsList[section-1]
            return cardList.count + 2
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: headerId, for: indexPath)
            return cell

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
                if let startTimeText = card.startTime, let endTimeText = card.endTime  {
                    cell.timeLabel.text = "\(startTimeText)-\(endTimeText)"
                } else {
                    cell.timeLabel.text = ""
                }
                return cell
            }
        }
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
            navigationController?.pushViewController(collectionVC, animated: true)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
                return 235
        } else {
           let cardList = cardsList[indexPath.section-1]
            if indexPath.row == 0 || indexPath.row == cardList.count + 1 {
                    return 50
            }
            return 92 + 20
        }
    }
}



