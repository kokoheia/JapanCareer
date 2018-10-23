//
//  SearchStudentCell.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/22.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//


import UIKit
import Firebase

final class SearchStudentCell: BaseCell {
    
    var profileImageView: UIImageView = {
        var iv = UIImageView()
        iv.image = UIImage(named: "origami")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 25.5
        iv.layer.masksToBounds = true
        return iv
    }()
    
    var nameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.text = "Kohei Arai"
        return label
    }()
    
    var schoolLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.myGrayColor
        label.text = "Carnegie Mellon University"
        return label
    }()
    
    var majorLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.myGrayColor
        label.text = "Computer Science / Junior"
        return label
    }()
    
    var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.myLightGrayColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupView() {
        super.setupView()
        self.backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 51).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 51).isActive = true
        
        addSubview(schoolLabel)
        schoolLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        schoolLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 5).isActive = true
        
        addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: schoolLabel.centerYAnchor, constant: -20).isActive = true
        
        addSubview(majorLabel)
        majorLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        majorLabel.centerYAnchor.constraint(equalTo: schoolLabel.centerYAnchor, constant: 15).isActive = true
    
        addSubview(separatorLine)
        separatorLine.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
}


