//
//  CompanyDescriptionView.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/05.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

class CompanyDescriptionView: UIView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let cellId = "cellId"
    
    lazy var contentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(CompanyDescriptionCell.self, forCellWithReuseIdentifier: cellId)
        cv.backgroundColor = .white
        return cv
    }()
    
    var contentsTitles = ["Title","Title","Title"]
    
    var contentsDescriptions = ["This is a sample text","This is a sample text.","This is a sample text."]


    override init(frame: CGRect) {
        super.init(frame: frame)       
        addSubview(contentCollectionView)
        contentCollectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentCollectionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        contentCollectionView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentsTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CompanyDescriptionCell
        cell.titleLabel.text = contentsTitles[indexPath.item]
        cell.detailLabel.text = contentsDescriptions[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


class CompanyDescriptionCell: BaseCell {
    var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var detailLabel: UILabel = {
        var label = UILabel()
        label.text = "This is a sample text."
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupView() {
        super.setupView()
        addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        addSubview(detailLabel)
        detailLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        detailLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
}


