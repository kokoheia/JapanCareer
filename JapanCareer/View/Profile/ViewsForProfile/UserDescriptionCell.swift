//
//  UserDescriptionCell.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/14.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

class UserDescriptionCell : BaseTableViewCell {
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11 + 2, weight: .regular)
        return label
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13 + 2, weight: .regular)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13 + 2, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    private var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.myGrayColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(timeLabel)
        timeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant:28).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(titleLabel)
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 230).isActive = true
        
        addSubview(detailLabel)
        detailLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        detailLabel.widthAnchor.constraint(equalToConstant: 330).isActive = true
        
        
        addSubview(separatorView)
        separatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
}
