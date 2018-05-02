//
//  CompanyDescription.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/10.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import Foundation

class CompanyInfo: Equatable {
    
    var type: CompanyInfoTitle?
    var titles: String?
    var details: String?
    
    init() {
        
    }
    
    convenience init(type: CompanyInfoTitle) {
        self.init()
        self.type = type
    }
    
    init(type: CompanyInfoTitle, titles: String, details: String) {
        self.type = type
        self.titles = titles
        self.details = details
    }
    
    init(dictionary: [String: String], type: CompanyInfoTitle) {
        self.titles = dictionary["title"]
        self.details = dictionary["detail"]
    }
    
    static func == (lhs: CompanyInfo, rhs: CompanyInfo) -> Bool {
        if lhs.titles == rhs.titles && lhs.details == rhs.details {
            return true
        }
        return false
    }
}

enum CompanyInfoTitle: String {
    case about
    case job
    case other
}
