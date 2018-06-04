//
//  HeaderTableViewCell.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/14.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

class HeaderTableViewCell: BaseTableViewCell {
    
    var delegate: TableDelegate?
    
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
    
    
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "origami")
        iv.backgroundColor = .white
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 46
        iv.layer.masksToBounds = true
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleEditProfile))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Student Name"
        label.font = UIFont.systemFont(ofSize: 17 + 2, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "University Name"
        label.font = UIFont.systemFont(ofSize: 14 + 2, weight: .regular)
        label.textAlignment = .center
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
    
    var editButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "edit500")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func handleEditProfile() {
        delegate?.handleSetupProfileImage()
    }
    
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
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        
        addSubview(footerView)
        footerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        footerView.topAnchor.constraint(equalTo: cardBackgroundView.bottomAnchor, constant: -1).isActive = true
        footerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(subtitleLabel)
        subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        subtitleLabel.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -30).isActive = true
        subtitleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        
        addSubview(editButton)
        editButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        editButton.topAnchor.constraint(equalTo: cardBackgroundView.topAnchor, constant: 15).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
}

