//
//  ChatMessageCell.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/02.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

final class ChatMessageCell: UICollectionViewCell {
        
    var textLabel: UILabel =  {
        let label = UILabel()
        label.text = "sample"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    var bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "origami")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    
    
    
    var bubbleViewWidthAnchor : NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        profileImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true

        
        addSubview(bubbleView)
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        bubbleViewLeftAnchor?.isActive = false
        
        bubbleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bubbleViewWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleViewWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        addSubview(textLabel)
        textLabel.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textLabel.topAnchor.constraint(equalTo:topAnchor).isActive = true
        textLabel.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -8).isActive = true
        textLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
