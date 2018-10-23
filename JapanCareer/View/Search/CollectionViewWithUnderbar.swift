//
//  CollectionViewWithUnderbar.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/14.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

final class CollectionViewWithUnderbar: UICollectionView  {
    var highlightingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        addSubview(highlightingView)
        highlightingView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        highlightingView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        highlightingView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        highlightingView.heightAnchor.constraint(equalToConstant: 5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
