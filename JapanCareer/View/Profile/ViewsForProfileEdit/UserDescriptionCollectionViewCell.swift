//
//  UserDescriptionCollectionViewCell.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/14.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit


class UserDescriptionCollectionViewCell : BaseCell {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13 + 2, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15 + 2, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.myGrayColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var textLabelHeight: NSLayoutConstraint?
    
    
    override func setupView() {
        super.setupView()
        
        addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        
        addSubview(textLabel)
        textLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 31).isActive = true
        textLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        textLabelHeight = textLabel.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -16-31)
        textLabelHeight?.isActive = true
        
        
        addSubview(separatorView)
        separatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalToConstant: 337).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
}
