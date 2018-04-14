//
//  StudyCard.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/06.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import Foundation

class ProfileCard: Equatable {
    var type: ProfileCardType?
    var sectionName: String?
    
    var title: String?
    var detailTitle: String?
    var startTime: String?
    var endTime: String?
    
    lazy var labelDataList = [title, detailTitle, startTime, endTime]
    
    init(type: ProfileCardType) {
        self.type = type
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
        if lhs.type == rhs.type, lhs.sectionName == rhs.sectionName, lhs.title == rhs.title, lhs.detailTitle == rhs.detailTitle, lhs.startTime == rhs.startTime, lhs.endTime == rhs.endTime {
            return true
        }
        return false
    }
}


enum ProfileCardType: String {
    case study = "Study"
    case intern = "Intern"
    case skill = "Skill"
    case language = "Language"
}
