//
//  File.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/18.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

final class HeaderCellWithButton: BaseTableViewCell {
    var headerClearView: UIView = {
        let iv = UIView()
        iv.backgroundColor = .clear
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var cardBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = cardCornerRadius
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "origami")
        iv.backgroundColor = .white
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 46
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Kohei Arai"
        label.font = UIFont.systemFont(ofSize: 17 + 2, weight: .medium)
        return label
    }()
    
    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Carnegie Mellon University"
        label.font = UIFont.systemFont(ofSize: 14 + 2, weight: .regular)
        return label
    }()
    
    var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = cardCornerRadius
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var messageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle("Send Message", for: .normal)
        button.backgroundColor = UIColor.applyButtonGreen
        button.setTitleColor(.white, for: .normal)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .clear
        let gapHeight: CGFloat = 100
        
        addSubview(headerClearView)
        headerClearView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headerClearView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        headerClearView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        headerClearView.heightAnchor.constraint(equalToConstant: gapHeight).isActive = true
        
        addSubview(cardBackgroundView)
        cardBackgroundView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cardBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: gapHeight).isActive = true
        cardBackgroundView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        cardBackgroundView.heightAnchor.constraint(equalTo: heightAnchor, constant: -gapHeight-50).isActive = true
        
        addSubview(profileImageView)
        profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 43).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 92).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 92).isActive = true
        
        addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 22).isActive = true
        
        addSubview(footerView)
        footerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        footerView.topAnchor.constraint(equalTo: cardBackgroundView.bottomAnchor, constant: -1).isActive = true
        footerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(subtitleLabel)
        subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        
        addSubview(messageButton)
        messageButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        messageButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 10).isActive = true
        messageButton.widthAnchor.constraint(equalToConstant: 202).isActive = true
        messageButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
}

