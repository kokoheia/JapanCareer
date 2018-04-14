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
    

    init(dictionary: Dictionary<String, AnyObject>) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
}
