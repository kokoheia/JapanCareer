//
//  BaseCell.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/10/23.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
