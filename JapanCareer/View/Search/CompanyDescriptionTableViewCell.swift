//
//  CompanyDescriptionTableViewCell.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/14.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

final class CompanyDescriptionTableViewCell: BaseTableViewCell {
    
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
    

    var editButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "edit500")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        addSubview(detailLabel)
        detailLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        detailLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -30).isActive = true
        
        addSubview(editButton)
        editButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        editButton.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
}
