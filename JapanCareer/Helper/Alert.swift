//
//  Alert.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/05/05.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

extension RegisterController {
    
    var missingBlankAlert = UIAlertController(title: "Coundn't register your account", message: "Please fill in all the blanks.", preferredStyle: .alert)
    missingBlankAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
    
    
}
