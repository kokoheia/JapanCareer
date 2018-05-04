//
//  UserCardView.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/04.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

class UserCardView: UICollectionViewCell {
    
    var userImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "shrine")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Company A"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Tokyo / Japan"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Company's description will come here. This is a sample text. This is a sample text. This is a sample text. This is a sample text. This is a sample text."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(userImage)
        userImage.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        userImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        userImage.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: 168).isActive = true
        
        addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true
        titleLabel.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 15).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        addSubview(subTitleLabel)
        subTitleLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 22).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 15).isActive = true
        subTitleLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        addSubview(detailLabel)
        detailLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        detailLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        detailLabel.widthAnchor.constraint(equalToConstant: 347).isActive = true
        detailLabel.heightAnchor.constraint(equalToConstant: 49).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}
