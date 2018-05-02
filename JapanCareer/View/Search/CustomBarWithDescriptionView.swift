//
//  CustomBar.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/05.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

let cellId = "cellId"
//
//class CustomBarWithDescriptionView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
//    
//    lazy var descriptionViewData = [aboutViewData, jobViewData, languageViewData]
//    var aboutViewData = CompanyInfo(type: .about)
//    var jobViewData = CompanyInfo(type: .job)
//    var languageViewData = CompanyInfo(type: .other)
//
//    var descriptionView : CompanyDescriptionView = {
//        var contentsTitles =  ["Title1","Title2","Title3"]
//        var contentsDescriptions = ["Company's description will come here. This is a sample text. This is a sample text. This is a sample text. This is a sample text. This is a sample text.", "Company's description will come here. This is a sample text. This is a sample text. This is a sample text. This is a sample text. This is a sample text.", "Company's description will come here. This is a sample text. This is a sample text. This is a sample text. This is a sample text. This is a sample text."]
//
//        let cdView = CompanyDescriptionView()
//        cdView.contentsTitles = contentsTitles
//        cdView.contentsDescriptions = contentsDescriptions
//        cdView.translatesAutoresizingMaskIntoConstraints = false
//        return cdView
//    }()
//
//    private lazy var containerView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.translatesAutoresizingMaskIntoConstraints = false
//        cv.register(customNavBarCell.self, forCellWithReuseIdentifier: cellId)
//        cv.dataSource = self
//        cv.delegate = self
//        return cv
//    }()
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(containerView)
//        containerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        containerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
//        containerView.heightAnchor.constraint(equalToConstant: 44).isActive = true
//
//        addSubview(highlightingView)
//        highlightLeftAnchor =  highlightingView.leftAnchor.constraint(equalTo: leftAnchor)
//        highlightLeftAnchor?.isActive = true
//        highlightingView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        highlightingView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3).isActive = true
//        highlightingView.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
//
//        addSubview(aboutLabel)
//        aboutLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
//        aboutLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//
//        addSubview(jobLabel)
//        jobLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        jobLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//
//        addSubview(langLabel)
//        langLabel.textAlignment = .right
//        langLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
//        langLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//
//        addSubview(descriptionView)
//        descriptionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        descriptionView.topAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
//        descriptionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
//        descriptionView.heightAnchor.constraint(equalToConstant: 339).isActive = true
//
//        fetchCompanyData()
//    }
//
//    private func fetchCompanyData() {
//        aboutViewData.titles = ["Title1","Title2","Title3"]
//        aboutViewData.details =  ["Company's description will come here. This is a sample text. This is a sample text. This is a sample text. This is a sample text. This is a sample text.", "Company's description will come here. This is a sample text. This is a sample text. This is a sample text. This is a sample text. This is a sample text.", "Company's description will come here. This is a sample text. This is a sample text. This is a sample text. This is a sample text. This is a sample text."]
//        jobViewData.titles = ["Title4","Title5","Title6"]
//        jobViewData.details = ["Company's description will come here. This is a sample text. This is a sample text. This is a sample text. This is a sample text. This is a sample text.", "Company's description will come here. This is a sample text. This is a sample text. This is a sample text. This is a sample text. This is a sample text.", "Company's description will come here. This is a sample text. This is a sample text. This is a sample text. This is a sample text. This is a sample text."]
//        languageViewData.titles =  ["Title7","Title8","Title9"]
//        languageViewData.details = ["Company's description will come here. This is a sample text. This is a sample text. This is a sample text. This is a sample text. This is a sample text.", "Company's description will come here. This is a sample text. This is a sample text. This is a sample text. This is a sample text. This is a sample text.", "Company's description will come here. This is a sample text. This is a sample text. This is a sample text. This is a sample text. This is a sample text."]
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 3
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! customNavBarCell
//         return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        highlightLeftAnchor?.constant = CGFloat(indexPath.item) * bounds.width / 3
//        UIView.animate(withDuration: 0.25) {
//            self.layoutIfNeeded()
//        }
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: bounds.width / 3, height: bounds.height)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    var aboutLabel = navLabel(frame: .zero, text: "About")
//    var jobLabel = navLabel(frame: .zero, text: "Job")
//    var langLabel = navLabel(frame: .zero, text: "Language")
//
//    var highlightingView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.mainColor
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//}

//var highlightLeftAnchor: NSLayoutConstraint?

class customNavBarCell: BaseCell {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
            titleLabel.textColor = isHighlighted ? UIColor.mainColor : UIColor.black
        }
    }
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? UIColor.mainColor : UIColor.black
        }
    }

    override func setupView() {
        super.setupView()
        addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
    
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class navLabel: UILabel {
    convenience init(frame: CGRect, text: String) {
        self.init(frame: frame)
        self.text = text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = UIFont.systemFont(ofSize: 17, weight: .medium)
        text = "Title"
        textColor = .white
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

