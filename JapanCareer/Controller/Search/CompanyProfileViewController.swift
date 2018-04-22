//
//  CompanyProfileViewController.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/04.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

class CompanyProfileViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var isStudent = false
    
    lazy var descriptionViewData = [aboutViewData, jobViewData, languageViewData]
    var aboutViewData = CompanyDescription()
    var jobViewData = CompanyDescription()
    var languageViewData = CompanyDescription()
    
    var currentTabNumber = 0
    var companyHeaderId = "companyHeaderId"
    var companyDescriptionId = "companyDescriptionId"
    var buttonCellId = "buttonCellId"
    var companyDescriptionViewId = "companyDescriptionViewId"
    let cellId = "cellId"
    
    var currentDescriptionViewData: CompanyDescription {
        return descriptionViewData[currentTabNumber]
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
        
        self.tabBarController?.tabBar.isHidden = true
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
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleChangeTest))
        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc private func handleChangeTest() {
        isStudent = !isStudent
        tableView.reloadData()
    }

    @objc private func handleEdit(_ sender: UIButton) {
        let cell = sender.superview as! CompanyDescriptionTableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let ev = EditCompanyDescription()
            let currentData = currentDescriptionViewData
            let title = currentData.titles![indexPath.row]
            let description = currentData.details![indexPath.row]
            ev.textInput.text = description
            ev.navigationItem.title = title
            ev.currentIndexPath = indexPath
            ev.currentTabNum = currentTabNumber
            navigationController?.pushViewController(ev, animated: true)
        }
    }

    private func fetchCompanyData() {
        aboutViewData.titles = ["About Company","Vision","Value"]
        aboutViewData.details =  ["Apple Inc. is an American multinational technology company headquartered in Cupertino, California, that designs, develops, and sells consumer electronics, computer software, and online services. The company's hardware products include the iPhone smartphone, the iPad tablet computer, the Mac personal computer, the iPod portable media player, the Apple Watch smartwatch,the Apple TV digital media player, and the HomePod smart speaker." ,  "We believe that we are on the face of the earth to make great products and that’s not changing. We are constantly focusing on innovating. We believe in the simple not the complex. We believe that we need to own and control the primary technologies behind the products that we make, and participate only in markets where we can make a significant contribution. We believe in saying no to thousands of projects, so that we can really focus on the few that are truly important and meaningful to us.", "Apple is more than just a company because its founding has some of the qualities of myth ... Apple is two guys in a garage undertaking the mission of bringing computing power, once reserved for big corporations, to ordinary individuals with ordinary budgets. The company's growth from two guys to a billion-dollar corporation exemplifies the American Dream."]
        jobViewData.titles = ["Software Engineer","Product manager","Designer"]
        jobViewData.details = ["Company's description will come here. This is a sample text. This is a sample text. This is a sample text. This is a sample text. This is a sample text.", "Company's description will come here. This is a sample text. This is a sample text. This is a sample text. This is a sample text. This is a sample text.", "Company's description will come here. This is a sample text. This is a sample text. This is a sample text. This is a sample text. This is a sample text."]
        languageViewData.titles =  ["Place","Language","Others"]
        languageViewData.details = ["Company's description will come here. This is a sample text. This is a sample text. This is a sample text. This is a sample text. This is a sample text.", "Company's description will come here. This is a sample text. This is a sample text. This is a sample text. This is a sample text. This is a sample text.", "Company's description will come here. This is a sample text. This is a sample text. This is a sample text. This is a sample text. This is a sample text."]
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return currentDescriptionViewData.titles!.count
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: companyHeaderId, for: indexPath) as! CompanyHeaderCell
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
            cell.titleLabel.text = currentDescriptionViewData.titles![indexPath.row]
            cell.detailLabel.text = currentDescriptionViewData.details![indexPath.row]
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
            if let text = currentDescriptionViewData.details?[indexPath.row] {
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
        let view = headerBackgroundView
        setupCollectionViewWithHighLighingView(on: view)
        return view
    }
    
    private func setupCollectionViewWithHighLighingView(on view: UIView) {
        view.addSubview(containerCollectionView)
        containerCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerCollectionView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(highlightingView)
        let constant = CGFloat(currentTabNumber) * tableView.bounds.width / 3

        highlightLeftAnchor =  highlightingView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: constant)
        highlightLeftAnchor?.isActive = true
        highlightingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        highlightingView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).isActive = true
        highlightingView.heightAnchor.constraint(equalToConstant: 4).isActive = true
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


