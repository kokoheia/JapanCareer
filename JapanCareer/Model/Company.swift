//
//  Company.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/30.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import Foundation

class Company {
    var id: String?
    var name : String?
    var email : String?
    var profileImageUrl: String?
    
    var aboutInfo = [CompanyInfo(type: .about)]
    var jobInfo = [CompanyInfo(type: .job)]
    var otherInfo = [CompanyInfo(type: .other)]
    
    lazy var infoList = [aboutInfo, jobInfo, otherInfo]
}

