//
//  UserDescriptionHeaderCell.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/14.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

class UserDescriptionHeaderCell: BaseTableViewCell {
    var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = cardCornerRadius
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var sectionNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Study"
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
        backgroundColor = .clear
        
        addSubview(headerView)
        headerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(sectionNameLabel)
        sectionNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        sectionNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(editButton)
        editButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        editButton.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
}
