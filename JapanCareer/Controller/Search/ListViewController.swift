//
//  SearchController.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/04.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var isStudent: Bool?
    var isFiltered = false
    
    private var companyCellId = "companyCellId"
    private var studentCellId = "studentCellId"
    
    private var students = [User]()
    private var companies = [Company]()
    
    private var filteringContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.clear.cgColor
        view.layer.shadowOpacity = 0
        return view
    }()
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return isStudent! ? 10 : 0
    }
    
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
        navigationItem.title = "Search"
//        let rightBarButtonItem = UIBarButtonItem(title: "change mode", style: .plain, target: self, action: #selector(handleChangeUser))
//        navigationItem.rightBarButtonItem = rightBarButtonItem
//        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
//        navigationItem.leftBarButtonItem = leftNavBarButton
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
//    @objc private func handleChangeUser() {
//        isStudent = !(isStudent!)
//        collectionView?.reloadData()
//    }
//
    func fetchStudents() {
        if !isStudent! {
            let ref = Database.database().reference().child("users").child("student")
            ref.observe(.childAdded, with: { [weak self] (snapshot) in
                //            print(snapshot)
                if let dictionary = snapshot.value as? Dictionary<String, AnyObject> {
                    let student = User(dictionary: dictionary)
                    student.id = snapshot.key
                    self?.students.append(student)
                    DispatchQueue.main.async {
                        self?.collectionView?.reloadData()
                    }
                }
            }, withCancel: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        checkUserType()

        collectionView?.register(UserCardView.self, forCellWithReuseIdentifier: companyCellId)
        collectionView?.register(SearchStudentCell.self, forCellWithReuseIdentifier: studentCellId)
        collectionView?.backgroundColor = UIColor.listBackgroundColor
        fetchStudents()
        fetchCompanies()
        setupNavBar()
//        collectionView?.contentInset = UIEdgeInsets(top: 38, left: 0, bottom: 0, right: 0)
        
        
//        view.addSubview(filteringContainerView)
//        filteringContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        filteringContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        filteringContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        filteringContainerView.heightAnchor.constraint(equalToConstant: 38).isActive = true
//
//        let filterViewFrame = CGRect(x: 0, y: 0, width: 101, height: 28)
        
//        let locationFilterView = FilteringMenuCell(frame: filterViewFrame, title: "Location", imageName: "pinE")
//        locationFilterView.translatesAutoresizingMaskIntoConstraints = false
//        filteringContainerView.addSubview(locationFilterView)
//        locationFilterView.leftAnchor.constraint(equalTo: filteringContainerView.leftAnchor, constant: 18).isActive = true
//        locationFilterView.topAnchor.constraint(equalTo: filteringContainerView.topAnchor).isActive = true
//        locationFilterView.widthAnchor.constraint(equalToConstant: 101).isActive = true
//        locationFilterView.heightAnchor.constraint(equalToConstant: 28).isActive = true
//
//
//        let jobFilterView = FilteringMenuCell(frame: filterViewFrame, title: "Job", imageName: "suitcaseE")
//        jobFilterView.translatesAutoresizingMaskIntoConstraints = false
//        filteringContainerView.addSubview(jobFilterView)
//        jobFilterView.centerXAnchor.constraint(equalTo: filteringContainerView.centerXAnchor).isActive = true
//        jobFilterView.topAnchor.constraint(equalTo: filteringContainerView.topAnchor).isActive = true
//        jobFilterView.widthAnchor.constraint(equalToConstant: 101).isActive = true
//        jobFilterView.heightAnchor.constraint(equalToConstant: 28).isActive = true
//
//        let languageFilterView = FilteringMenuCell(frame: filterViewFrame, title: "Language", imageName: "languageE")
//        languageFilterView.translatesAutoresizingMaskIntoConstraints = false
//        filteringContainerView.addSubview(languageFilterView)
//        languageFilterView.rightAnchor.constraint(equalTo: filteringContainerView.rightAnchor, constant: -18).isActive = true
//        languageFilterView.topAnchor.constraint(equalTo: filteringContainerView.topAnchor).isActive = true
//        languageFilterView.widthAnchor.constraint(equalToConstant: 101).isActive = true
//        languageFilterView.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
    private func setupNavBar() {
        if !isStudent! {
            let barButtonItem = UIBarButtonItem(title: "Applying", style: .plain, target: self, action: #selector(handleFilterApplyingStudents))
            navigationItem.rightBarButtonItem = barButtonItem
        }
        
    }
    
    @objc private func handleFilterApplyingStudents() {
        if !isFiltered {
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            students = []
            let ref = Database.database().reference().child("user-apply").child(uid)
            ref.observe(.childAdded, with: { (snapshot) in
                let studentId = snapshot.key
                let userRef = Database.database().reference().child("users").child("student").child(studentId)
                userRef.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                    if let dictioary = snapshot.value as? [String: AnyObject] {
                        let student = User(dictionary: dictioary)
                        student.id = snapshot.key
                        self?.students.append(student)
                        DispatchQueue.main.async {
                            self?.collectionView?.reloadData()
                            self?.isFiltered = true
                        }
                    }
                    }, withCancel: nil)
            }, withCancel: nil)
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.students = []
                self?.fetchStudents()
                self?.isFiltered = false
            }
        }
    }
    
    func fetchCompanies() {
        if isStudent! {
            let ref = Database.database().reference().child("users").child("company")
            ref.observe(.childAdded, with: { [weak self] (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let company = Company(dictionary: dictionary)
                    company.id = snapshot.key
                    self?.companies.append(company)
                    DispatchQueue.main.async {
                        self?.collectionView?.reloadData()
                    }
                }
            }, withCancel: nil)
        }
    }
    
    private func checkUserType() {
        if let rootTabBarC = UIApplication.shared.keyWindow?.rootViewController as? CustomTabBarController {
            isStudent = rootTabBarC.isStudent
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isStudent! {
            return companies.count
            
        } else {
            return students.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isStudent! {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: companyCellId, for: indexPath) as! UserCardView
            let company = companies[indexPath.row]
            if let name = company.name {
                cell.titleLabel.text = name
            }
            if let headerImageUrlStr = company.headerImageUrlStr {
                cell.userImage.loadImageWithCache(with: headerImageUrlStr)
            }
            
            if let place = company.place {
                cell.subTitleLabel.text = place
            }
            
            if let aboutDescription = company.aboutInfo[0].details {
                cell.detailLabel.text = aboutDescription
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: studentCellId, for: indexPath) as! SearchStudentCell
            let student = students[indexPath.item]
            cell.nameLabel.text = student.name
            if let imageUrlString = student.profileImageUrl {
                cell.profileImageView.loadImageWithCache(with: imageUrlString)
            }
            if student.studyList.count > 0 {
                cell.schoolLabel.text = student.studyList[0].title
                cell.majorLabel.text = student.studyList[0].detailTitle
            }
            
            
            return cell
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isStudent! {
            let companyVC = CompanyProfileViewController()
            companyVC.company = companies[indexPath.item]
            companyVC.isStudent = isStudent
            navigationController?.pushViewController(companyVC, animated: true)
        } else {
            let student = students[indexPath.item]
            let vc = ProfileController()
            vc.user = student
            vc.isStudent = isStudent
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.bounds.width
        let height: CGFloat = isStudent! ? 284 : 80
        return CGSize(width: width, height: height)
        
        
    }
    
}
