//
//  UserCell.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/03/29.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    var message: Message? {
        didSet {
            setupNameAndProfileImage()
            detailTextLabel?.text = message?.text
            
            if let seconds = message?.timestamp?.doubleValue {
                let date = Date(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: date)
            }
            
        }
    }
    private func setupNameAndProfileImage() {
        var chatPartnerId: String? {
            if message?.fromId == Auth.auth().currentUser?.uid {
                return message?.toId
            } else {
                return message?.fromId
            }
        }
        
        if let id = chatPartnerId {
            let ref = Database.database().reference().child("users").child(id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.textLabel?.text = dictionary["name"] as? String
                    
                    if let imageUrlString = dictionary["profileImageUrl"] as? String {
                        self.profileImageView.loadImageWithCache(with: imageUrlString)
                    }
                    
                }
            }, withCancel: nil)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 80, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 80, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    var profileImageView: UIImageView = {
        var iv = UIImageView()
        iv.image = UIImage(named: "origami")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 25.5
        iv.layer.masksToBounds = true
        return iv
    }()
    
    var timeLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.myGrayColor
        label.textAlignment = .right
        return label
    }()
    
    var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.myLightGrayColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 51).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 51).isActive = true
        
        addSubview(timeLabel)
        timeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -31).isActive = true
        timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 99).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        
        addSubview(separatorLine)
        separatorLine.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorLine.widthAnchor.constraint(equalToConstant: 294).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

