//
//  SearchController.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/04.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

class ListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    private var cellId = "cellId"
    
    private var filteringContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.clear.cgColor
        view.layer.shadowOpacity = 0
        return view
    }()
    
    private var searchBar : UISearchBar = {
        let sb = UISearchBar()
        sb.searchBarStyle = .prominent
        sb.frame = CGRect(x: 0, y: 0, width: 343, height: 20)
        sb.placeholder = "Search..."
        sb.isTranslucent = false
        return sb
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImage(for: UIBarMetrics.default), for:UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        navigationItem.leftBarButtonItem = leftNavBarButton
        self.tabBarController?.tabBar.isHidden = false
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self

        collectionView?.register(UserCardView.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = UIColor.listBackgroundColor
        collectionView?.contentInset = UIEdgeInsets(top: 38, left: 0, bottom: 0, right: 0)
        
        view.addSubview(filteringContainerView)
        filteringContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        filteringContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        filteringContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        filteringContainerView.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        let filterViewFrame = CGRect(x: 0, y: 0, width: 101, height: 28)
        
        let locationFilterView = FilteringMenuCell(frame: filterViewFrame, title: "Location", imageName: "pinE")
        locationFilterView.translatesAutoresizingMaskIntoConstraints = false
        filteringContainerView.addSubview(locationFilterView)
        locationFilterView.leftAnchor.constraint(equalTo: filteringContainerView.leftAnchor, constant: 18).isActive = true
        locationFilterView.topAnchor.constraint(equalTo: filteringContainerView.topAnchor).isActive = true
        locationFilterView.widthAnchor.constraint(equalToConstant: 101).isActive = true
        locationFilterView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        
        let jobFilterView = FilteringMenuCell(frame: filterViewFrame, title: "Job", imageName: "suitcaseE")
        jobFilterView.translatesAutoresizingMaskIntoConstraints = false
        filteringContainerView.addSubview(jobFilterView)
        jobFilterView.centerXAnchor.constraint(equalTo: filteringContainerView.centerXAnchor).isActive = true
        jobFilterView.topAnchor.constraint(equalTo: filteringContainerView.topAnchor).isActive = true
        jobFilterView.widthAnchor.constraint(equalToConstant: 101).isActive = true
        jobFilterView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        let languageFilterView = FilteringMenuCell(frame: filterViewFrame, title: "Language", imageName: "languageE")
        languageFilterView.translatesAutoresizingMaskIntoConstraints = false
        filteringContainerView.addSubview(languageFilterView)
        languageFilterView.rightAnchor.constraint(equalTo: filteringContainerView.rightAnchor, constant: -18).isActive = true
        languageFilterView.topAnchor.constraint(equalTo: filteringContainerView.topAnchor).isActive = true
        languageFilterView.widthAnchor.constraint(equalToConstant: 101).isActive = true
        languageFilterView.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(CompanyProfileViewController(), animated: true)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width
        let height: CGFloat = 284
        return CGSize(width: width, height: height)
    }
    
}
