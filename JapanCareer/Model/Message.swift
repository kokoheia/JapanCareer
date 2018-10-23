//
//  Message.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/01.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import Foundation
import Firebase

final class Message {
    var toId: String?
    var fromId: String?
    var timestamp: NSNumber?
    var text: String?
    
    func chatPartnerId() -> String? {
        return toId == Auth.auth().currentUser?.uid ? fromId : toId
    }

    init(dictionary: [String: AnyObject]) {
        self.toId = dictionary["toId"] as? String
        self.fromId = dictionary["fromId"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
        self.text = dictionary["text"] as? String
    }
}
