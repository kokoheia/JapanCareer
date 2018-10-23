//
//  ButtonWithImage.swift
//  JapanCareer
// 
//  Created by Kohei Arai on 2018/03/30.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

class ButtonWithImage: UIView {
    
    var icon: UIImageView = {
        var iv = UIImageView()
        iv.image = UIImage(named: "back")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var title: UILabel = {
        var label = UILabel()
        label.text = "title"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var filter: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(icon)
        icon.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 21).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        addSubview(title)
        title.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 1).isActive = true
        title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        title.widthAnchor.constraint(equalToConstant: 80).isActive = true
        title.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(filter)
        filter.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        filter.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        filter.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        filter.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



