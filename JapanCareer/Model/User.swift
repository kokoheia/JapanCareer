//
//  User.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/03/31.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import Foundation
import Firebase

class User: NSObject {
    var id: String?
    var name : String?
    var email : String?
    var profileImageUrl: String?
    
    var studyCard = ProfileCard(type: .study)
    var internCard = ProfileCard(type: .intern)
    var skillCard = ProfileCard(type: .skill)
    var languageCard = ProfileCard(type: .language)
    var linkCard = ProfileCard(type: .link)
    
    lazy var studyList = [studyCard]
    lazy var internList = [internCard]
    lazy var skillList = [skillCard]
    lazy var languageList = [languageCard]
    lazy var linkList = [linkCard]

    
    lazy var cardList = [studyList, internList, skillList, languageList, linkList]
    
//    func getCurrentSchool() -> String {
//        var school:String?
//        var latestYear = 1000
//        var latestMonth = 0
//        for study in studyList {
//            if let startY = study.startYear {
//                if startY > latestYear {
//                    return study.start
//                }
//                if startY >= latestYear {
//                    latestYear = start
//                    if startM = study.startMonth {
//                        if startM > latestYear {
//
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    func sortCardLists() {
        cardList[0].sort(by: { (card1, card2) -> Bool in
            if let timeInt1 = card1.startTimestamp?.intValue, let timeInt2 = card2.startTimestamp?.intValue {
                return timeInt1 > timeInt2
            }
            return true
        })
        
        cardList[1].sort(by: { (card1, card2) -> Bool in
            if let timeInt1 = card1.startTimestamp?.intValue, let timeInt2 = card2.startTimestamp?.intValue {
                return timeInt1 > timeInt2
            }
            return true
        })
    }


    init(dictionary: Dictionary<String, AnyObject>) {
        super.init()
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        
        if let dict = dictionary["study"] as? Dictionary<String, AnyObject> {
            if let values = Array(dict.values) as? [Dictionary<String, AnyObject>] {
                studyList = []
                for index in values.indices {
                    let dict = values[index]
                    let profileCard = ProfileCard(dictionary: dict, type: .study)
                    studyList.append(profileCard)
                }
            }
        }
        
        if let dict = dictionary["intern"] as? Dictionary<String, AnyObject> {
            if let values = Array(dict.values) as? [Dictionary<String, AnyObject>] {
                internList = []
                for index in values.indices {
                    let dict = values[index]
                    let profileCard = ProfileCard(dictionary: dict, type: .intern)
                    internList.append(profileCard)
                }
            }
        }
        
        if let dict = dictionary["skill"] as? Dictionary<String, AnyObject> {
            if let values = Array(dict.values) as? [Dictionary<String, AnyObject>] {
                skillList = []
                for index in values.indices {
                    let dict = values[index]
                    let profileCard = ProfileCard(dictionary: dict, type: .skill)
                    skillList.append(profileCard)
                }
            }
        }
        
        if let dict = dictionary["language"] as? Dictionary<String, AnyObject> {
            if let values = Array(dict.values) as? [Dictionary<String, AnyObject>] {
                languageList = []
                for index in values.indices {
                    let dict = values[index]
                    let profileCard = ProfileCard(dictionary: dict, type: .language)
                    languageList.append(profileCard)
                }
            }
        }
        
        if let dict = dictionary["link"] as? Dictionary<String, AnyObject> {
            if let values = Array(dict.values) as? [Dictionary<String, AnyObject>] {
                linkList = []
                for index in values.indices {
                    let dict = values[index]
                    let profileCard = ProfileCard(dictionary: dict, type: .link)
                    linkList.append(profileCard)
                }
            }
        }
    }
}
