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
    var place: String?
    var domain: String?
    var email : String?
    var profileImageUrl: String?
    var headerImageUrlStr: String?
    
    var aboutInfo = [CompanyInfo(type: .about)]
    var jobInfo = [CompanyInfo(type: .job)]
    var otherInfo = [CompanyInfo(type: .other)]
    
    lazy var infoList = [aboutInfo, jobInfo, otherInfo]
    
    init() {}
    
    init(dictionary: Dictionary<String, AnyObject>) {

        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        self.headerImageUrlStr = dictionary["headerImageUrl"] as? String
        self.domain = dictionary["domain"] as? String
        self.place = dictionary["place"] as? String
        
        if let dict = dictionary["about"] as? Dictionary<String, AnyObject> {
            print(dict)
            aboutInfo = []
            let sortedKeys = Array(dict.keys).sorted(by: <)
            for index in 0..<dict.count {
                let key = sortedKeys[index]
                if let aboutDict = dict[key] as? [String: String]{
                    let about = CompanyInfo(dictionary: aboutDict, type: .about)
                    aboutInfo.append(about)
                }
            }
        }
        
        if let dict = dictionary["job"] as? Dictionary<String, AnyObject> {
            if let values = Array(dict.values) as? [Dictionary<String, AnyObject>] {
                jobInfo = []
                for index in values.indices {
                    if let dict = values[index] as? [String: String] {
                        let job = CompanyInfo(dictionary: dict, type: .job)
                        jobInfo.append(job)
                    }
                }
            }
        }
        
        if let dict = dictionary["other"] as? Dictionary<String, AnyObject> {
            if let values = Array(dict.values) as? [Dictionary<String, AnyObject>] {
                otherInfo = []
                for index in values.indices {
                    if let dict = values[index] as? [String: String] {
                        let other = CompanyInfo(dictionary: dict, type: .other)
                        otherInfo.append(other)
                    }
                }
            }
        }
        
        
       
    }
}

