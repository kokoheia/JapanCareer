//
//  CompanyDescriptionViewCell.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/10/23.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

final class CompanyDescriptionCell: BaseCell {
    var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var detailLabel: UILabel = {
        var label = UILabel()
        label.text = "This is a sample text."
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupView() {
        super.setupView()
        addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        addSubview(detailLabel)
        detailLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        detailLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
}
