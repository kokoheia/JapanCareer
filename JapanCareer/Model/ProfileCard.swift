//
//  StudyCard.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/06.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import Foundation

final class ProfileCard: Equatable, NSCopying {
    
    var type: ProfileCardType?
    var sectionName: String?

    var title: String?
    var detailTitle: String?
    var startTimestamp: NSNumber?
    var endTimestamp: NSNumber?
    
    lazy var labelDataList = [title, detailTitle, startTimestamp, endTimestamp]

    convenience init(type: ProfileCardType) {
        self.init()
        self.type = type
    }
    
    convenience init(dictionary: [String: AnyObject], type: ProfileCardType) {
        self.init()
        self.type = type
        self.title = dictionary["title"] as? String
        self.detailTitle = dictionary["subtitle"] as? String
        self.startTimestamp = dictionary["startTime"] as? NSNumber
        self.endTimestamp = dictionary["endTime"] as? NSNumber
    }
    
    func info() {
        print(self.type)
        print(self.sectionName)
        print(self.title)
        print(self.detailTitle)
        print(self.startTimestamp)
        print(self.endTimestamp)
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
        case .link:
            return ["Title", "Link"]
        }
    }
    
    static func == (lhs: ProfileCard, rhs: ProfileCard) -> Bool {
        if lhs.title == rhs.title, lhs.detailTitle == rhs.detailTitle, lhs.startTimestamp == rhs.startTimestamp, lhs.endTimestamp == rhs.endTimestamp {
            return true
        }
        return false
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ProfileCard()
        copy.title = title
        copy.detailTitle = detailTitle
        copy.startTimestamp = startTimestamp
        copy.endTimestamp = endTimestamp
        return copy
    }
}


enum ProfileCardType: String, CaseIterable  {
    case study = "Study"
    case intern = "Intern"
    case skill = "Skill"
    case language = "Language"
    case link = "Link"
}
