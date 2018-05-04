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
    
    lazy var studyList = [studyCard]
    lazy var internList = [internCard]
    lazy var skillList = [skillCard]
    lazy var languageList = [languageCard]

    
//    lazy var studyList = [ProfileCard]()
//    lazy var internList = [ProfileCard]()
//    lazy var skillList = [ProfileCard]()
//    lazy var languageList = [ProfileCard]()
    
    lazy var cardList = [studyList, internList, skillList, languageList]


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
    }
    
//    init(profileDictionary: Dictionary<String, AnyObject>, studyDictionary: Dictionary<String, AnyObject>) {
//        self.name = profileDictionary["name"] as? String
//        self.school = profileDictionary[]
//    }
}
