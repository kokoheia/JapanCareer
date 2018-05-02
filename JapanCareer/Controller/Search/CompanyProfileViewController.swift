//
//  CompanyProfileViewController.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/04.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit
import Firebase

class CompanyProfileViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var isStudent = false
    
    var company: Company?
    
    
    var currentTabNumber = 0
    var companyHeaderId = "companyHeaderId"
    var companyDescriptionId = "companyDescriptionId"
    var buttonCellId = "buttonCellId"
    var companyDescriptionViewId = "companyDescriptionViewId"
    let cellId = "cellId"
    
    var currentDescriptionViewData: [CompanyInfo] {
        return company?.infoList[currentTabNumber] ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CompanyHeaderCell.self, forCellReuseIdentifier: companyHeaderId)
        tableView.register(CompanyDescriptionTableViewCell.self, forCellReuseIdentifier: companyDescriptionId)
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: buttonCellId)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = .clear
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        containerCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: [])
        setupNavBar()
        
//        self.tabBarController?.tabBar.isHidden = true
        tableView.backgroundColor = .white
        
        fetchCompanyData()
    }
    
    private func setupEditButton(with cell: CompanyDescriptionTableViewCell) {
        if isStudent {
            cell.editButton.isHidden = true
            cell.editButton.isEnabled = false
        } else {
            cell.editButton.isHidden = false
            cell.editButton.isEnabled = true
            cell.editButton.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
        }
    }
    
    private func setupNavBar() {
        let editButton = UIBarButtonItem(title: "Change Mode", style: .plain, target: self, action: #selector(handleChangeTest))
        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc private func handleChangeTest() {
        isStudent = !isStudent
        tableView.reloadData()
    }

    @objc private func handleEdit(_ sender: UIButton) {
        let cell = sender.superview as! CompanyDescriptionTableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let ev = EditCompanyDescriptionController()
            let currentData = currentDescriptionViewData
            let title = currentData[indexPath.row].titles
            let description = currentData[indexPath.row].details
            ev.textInput.text = description
            ev.navigationItem.title = title
            ev.currentIndexPath = indexPath
//            ev.currentTabNum = currentTabNumber
//
            let layout = UICollectionViewFlowLayout()
            let companyEditC = CompanyEditController(collectionViewLayout: layout)
            companyEditC.infoList = currentDescriptionViewData
            companyEditC.currentTabNumber = currentTabNumber
            companyEditC.currentIndexPath = indexPath
            navigationController?.pushViewController(companyEditC, animated: true)
        }
    }

    private func fetchCompanyData() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("couldn't get uid")
            return
        }
        
        company = Company()
        
        company?.aboutInfo = []
        company?.jobInfo = []
        company?.otherInfo = []
        
        let ref = Database.database().reference().child("users").child("company").child(uid)
        ref.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject], let name =  dictionary["name"] as? String, let url = dictionary["profileImageUrl"] as? String {
                self?.company?.name = name
                self?.company?.profileImageUrl = url
            }
        }
        
        let aboutRef = ref.child("about")
        let jobRef = ref.child("job")
        let otherRef = ref.child("other")
        
        aboutRef.observe(.childAdded, with: { [weak self] (snapshot) in
            if let dictionary = snapshot.value as? [String: String] {
                let aboutInfo = CompanyInfo(dictionary: dictionary, type: .about)
                self?.company?.infoList[0].append(aboutInfo)
            }
        }, withCancel: nil)

        jobRef.observe(.childAdded, with: { [weak self] (snapshot) in
            if let dictionary = snapshot.value as? [String: String] {
                let jobInfo = CompanyInfo(dictionary: dictionary, type: .job)
                self?.company?.infoList[1].append(jobInfo)
            }
        }, withCancel: nil)

        otherRef.observe(.childAdded, with: { [weak self] (snapshot) in
            if let dictionary = snapshot.value as? [String: String] {
                let otherInfo = CompanyInfo(dictionary: dictionary, type: .other)
                self?.company?.infoList[2].append(otherInfo)
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return isStudent ? 2 : 1
        case 1:
            return currentDescriptionViewData.count
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: companyHeaderId, for: indexPath) as! CompanyHeaderCell
                if let name = company?.name, let imageUrlStr = company?.profileImageUrl {
                    cell.companyNameLabel.text = company?.name
                    cell.profileImageView.loadImageWithCache(with: imageUrlStr)
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: buttonCellId, for: indexPath) as! ButtonTableViewCell
                cell.cellButton.addTarget(self, action: #selector(handleApply), for: .touchUpInside)
                cell.cellButton.setTitle("Apply", for: .normal)
                cell.cellButton.setTitleColor(.white, for: .normal)
                return cell
            }
           
        case 1 :
            let cell = tableView.dequeueReusableCell(withIdentifier: companyDescriptionId, for: indexPath) as! CompanyDescriptionTableViewCell
            cell.titleLabel.text = currentDescriptionViewData[indexPath.row].titles
            cell.detailLabel.text = currentDescriptionViewData[indexPath.row].details
            setupEditButton(with: cell)
            return cell
        default:
            return UITableViewCell()
        }
    }

    @objc private func handleApply(_ sender: UIButton) {
        sender.backgroundColor = UIColor.applyButtonHighlightedGreen
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in
            sender.backgroundColor = UIColor.applyButtonGreen
            timer.invalidate()
        }
        print(123)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0{
                return 250
            }
            return 50
        case 1:
            var height: CGFloat = 200
            if let text = currentDescriptionViewData[indexPath.row].details {
                height = estimatedFrame(for: text).height + 60
            }

            return height
        default:
            return 50
        }
    }

    
    private func estimatedFrame(for text: String) -> CGRect {
        let size = CGSize(width: view.bounds.width-30, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15, weight: .regular)], context: nil)
    }
    
    lazy var headerBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    
    lazy var containerCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.allowsSelection = true
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.register(customNavBarCell.self, forCellWithReuseIdentifier: cellId)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    var highlightingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        super.tableView(tableView, viewForHeaderInSection: section)
        let view = headerBackgroundView
        setupCollectionViewWithHighLighingView(on: view)
        return view
    }
    
    var highlightLeftAnchor: NSLayoutConstraint?
    
    private func setupCollectionViewWithHighLighingView(on view: UIView) {
        view.addSubview(containerCollectionView)
        containerCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerCollectionView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
//        view.addSubview(highlightingView)
//
//        highlightLeftAnchor =  highlightingView.leftAnchor.constraint(equalTo: view.leftAnchor)
//        highlightLeftAnchor?.isActive = true
//        highlightingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        highlightingView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).isActive = true
//        highlightingView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }


    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerHeight: CGFloat
        
        switch section {
        case 0:
            headerHeight = CGFloat.leastNonzeroMagnitude
        case 1:
            headerHeight = 44
        default:
            headerHeight = 50
        }
        
        return headerHeight
    }

}


