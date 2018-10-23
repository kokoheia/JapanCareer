//
//  FilteringMenuCell.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/04.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

class FilteringMenuCell: UIView {
    
    var iconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "origami")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "sample"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    convenience init(frame: CGRect, title: String, imageName: String) {
        self.init(frame: frame)
        backgroundColor = UIColor.filteringMenuClear
        layer.cornerRadius = 7
        layer.masksToBounds = true
        titleLabel.text = title
        if let image = UIImage(named: imageName) {
            iconImage.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.filteringMenuClear
        addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 7).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        addSubview(iconImage)
        iconImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        iconImage.topAnchor.constraint(equalTo: topAnchor, constant: 7).isActive = true
        iconImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
        iconImage.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
