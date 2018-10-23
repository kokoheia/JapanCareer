//
//  FooterTableViewCell.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/14.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

final class FooterTableViewCell: BaseTableViewCell {
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        layer.cornerRadius = cardCornerRadius
        layer.masksToBounds = true
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
}
