//
//  StudyCard.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/06.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import Foundation

class ProfileCard: Equatable, NSCopying {
    
    
    var type: ProfileCardType?
    var sectionName: String?
    
    var title: String?
    var detailTitle: String?
    var startTime: String?
    var endTime: String?
    
    lazy var labelDataList = [title, detailTitle, startTime, endTime]
    
    convenience init(type: ProfileCardType) {
        self.init()
        self.type = type
    }
    
    convenience init(dictionary: [String: AnyObject]) {
        self.init()
        self.title = dictionary["title"] as? String
        self.detailTitle = dictionary["subtitle"] as? String
        self.startTime = dictionary["startTime"] as? String
        self.endTime = dictionary["endTime"] as? String
        
    }
    
    func info() {
        print(self.type)
        print(self.sectionName)
        print(self.title)
        print(self.detailTitle)
        print(self.startTime)
        print(self.endTime)
    }
    
    func editTitles() -> [String] {
        switch type! {
        case .study:
            return ["School", "Major", "Start Year", "End Year"]
        case .intern:
            return ["Company", "Position", "Start Year", "End Year"]
        case .skill:
            return ["Title", "Experience"]
        case .language:
            return ["Language", "Level"]
        }
    }
    
    static func == (lhs: ProfileCard, rhs: ProfileCard) -> Bool {
        if lhs.title == rhs.title, lhs.detailTitle == rhs.detailTitle, lhs.startTime == rhs.startTime, lhs.endTime == rhs.endTime {
            return true
        }
        return false
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ProfileCard()
        copy.title = title
        copy.detailTitle = detailTitle
        copy.startTime = startTime
        copy.endTime = endTime
        return copy
    }
}


enum ProfileCardType: String {
    case study = "Study"
    case intern = "Intern"
    case skill = "Skill"
    case language = "Language"
}
