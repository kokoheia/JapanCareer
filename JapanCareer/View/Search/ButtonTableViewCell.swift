//
//  ButtonTableViewCell.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/14.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

class ButtonTableViewCell: BaseTableViewCell {
    
    var cellButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.applyButtonGreen
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(cellButton)
        cellButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cellButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cellButton.widthAnchor.constraint(equalToConstant: 202).isActive = true
        cellButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        addSubview(separatorView)
        separatorView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
}


