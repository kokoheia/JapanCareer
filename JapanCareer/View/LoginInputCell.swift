//
//  LoginInputCell.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/03/29.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

class LoginInputCell: UIView, UITextFieldDelegate {
    
    
    var imageIcon : UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "origami")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var textInput: UITextField = {
        var textField = UITextField()
        textField.textColor = .white
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "title"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var underBar: UIView = {
        var bar = UIView()
        bar.backgroundColor = .white
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        textInput.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    private func setupViews() {
        addSubview(imageIcon)
        addSubview(textInput)
        addSubview(titleLabel)
        addSubview(underBar)
        
        imageIcon.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageIcon.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: imageIcon.rightAnchor, constant: 12).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        textInput.leftAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        textInput.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textInput.widthAnchor.constraint(greaterThanOrEqualToConstant: 255).isActive = true
        textInput.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        underBar.leftAnchor.constraint(equalTo: leftAnchor, constant: 42).isActive = true
        underBar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        underBar.widthAnchor.constraint(equalToConstant: 311).isActive = true
        underBar.heightAnchor.constraint(equalToConstant: 1).isActive = true
            }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
