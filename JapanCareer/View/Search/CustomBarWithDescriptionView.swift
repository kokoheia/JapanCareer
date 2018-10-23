//
//  CustomBar.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/05.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

final class CustomNavBarCell: BaseCell {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
            titleLabel.textColor = isHighlighted ? UIColor.mainColor : UIColor.black
        }
    }
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? UIColor.mainColor : UIColor.black
        }
    }

    override func setupView() {
        super.setupView()
        addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}



