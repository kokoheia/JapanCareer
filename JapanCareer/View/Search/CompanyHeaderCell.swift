//
//  CompanyHeaderCell.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/14.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

final class CompanyHeaderCell: BaseTableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: TableDelegate?
    
    lazy var headerImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "shrine")
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(pickUpHeaderImage))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "apple-logo2")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 13
        iv.layer.masksToBounds = true
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.gray.cgColor
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(pickUpProfileImage))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    @objc func pickUpProfileImage() {
        delegate?.handleSetupProfileImage()
    }
    
    @objc func pickUpHeaderImage() {
        delegate?.handleSetupHeaderImage()
    }
    
    
    var descriptionBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    var companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    var companyPlaceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    var companyIndustryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    var editButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "edit500")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private func setupCompanyBody() {
        
        contentView.addSubview(descriptionBackground)
        descriptionBackground.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        descriptionBackground.topAnchor.constraint(equalTo: headerImageView.bottomAnchor).isActive = true
        descriptionBackground.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        descriptionBackground.heightAnchor.constraint(equalToConstant: 119).isActive = true

        contentView.addSubview(profileImageView)
        profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: headerImageView.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 92).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 92).isActive = true
        
        descriptionBackground.addSubview(editButton)
        editButton.rightAnchor.constraint(equalTo: descriptionBackground.rightAnchor, constant: -30).isActive = true
        editButton.topAnchor.constraint(equalTo: descriptionBackground.topAnchor, constant: 30).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        descriptionBackground.addSubview(companyNameLabel)
        companyNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        companyNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
        companyNameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        
        descriptionBackground.addSubview(companyPlaceLabel)
        companyPlaceLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        companyPlaceLabel.topAnchor.constraint(equalTo: companyNameLabel.bottomAnchor, constant: 4).isActive = true
        companyNameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true

        descriptionBackground.addSubview(companyIndustryLabel)
        companyIndustryLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        companyIndustryLabel.topAnchor.constraint(equalTo: companyPlaceLabel.bottomAnchor, constant: 4).isActive = true
        companyNameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
    }
    
    private func setupHeader() {
        contentView.addSubview(headerImageView)
        headerImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        headerImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headerImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        headerImageView.heightAnchor.constraint(equalToConstant: 118).isActive = true
        
    }
    override func setupViews() {
        super.setupViews()
        backgroundColor = .clear
        setupHeader()
        setupCompanyBody()
    }
}

protocol TableDelegate {
    func handleSetupProfileImage()
    func handleSetupHeaderImage()
}
