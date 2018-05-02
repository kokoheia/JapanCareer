//
//  CompanyEditController.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/05/01.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit
import Firebase


class CompanyEditController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var isStudent: Bool?
    var currentTabNumber: Int?
    var currentIndexPath: IndexPath?
    
    var infoList = [CompanyInfo]()
    var currentEditingType: CompanyInfoTitle? {
        return infoList[0].type
    }
    
    var selectedIndex: Int?
    lazy var originalCardList = infoList

    
    
    private let descriptionViewId = "descriptionViewId"
    private let descriptionViewHeaderId = "descriptionViewHeaderId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        collectionView?.register(UserDescriptionCollectionViewCell.self, forCellWithReuseIdentifier: descriptionViewId)
        collectionView?.register(EditCollectionViewHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: descriptionViewHeaderId)
        collectionView?.backgroundColor = .white
        
        if let indexPath = currentIndexPath {
            let refinedPath = IndexPath(item: 0, section: indexPath.row)
            DispatchQueue.main.async { [weak self] in
                self?.collectionView?.scrollToItem(at: refinedPath, at: .top, animated: true)
            }
        }
    }
    
    private func setupNavigationBar() {
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        let saveBarButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        navigationItem.rightBarButtonItems = [saveBarButton, addBarButton]
        if let companyVC = navigationController?.viewControllers.first as? CompanyProfileViewController {
            if let typeStr = companyVC.currentDescriptionViewData[0].type?.rawValue {
                navigationItem.title = "Edit \(typeStr)"
            }
        }
        
    }
    
    @objc private func handleAdd() {
        
        if let type = currentEditingType {
            let newInfo = CompanyInfo(type: type, titles: "", details: "")
            if !infoList.contains(newInfo) {
                infoList.append(newInfo)
                collectionView?.reloadData()
                let section = infoList.count-1
                let indexPath = IndexPath(item: 0, section: section)
                collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.top, animated: true)
            }
        }
    }
    
    
    @objc private func handleSave() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("couldn't get current user")
            return
        }
        
        if let type = infoList[0].type?.rawValue {
            let ref = Database.database().reference().child("users").child("company").child(uid).child(type)
            
            var values = [String: String]()
            
            for i in 0..<infoList.count {
                let key = "\(type)\(i+1)"
                let newRef = ref.child(key)
                values["title"] = infoList[i].titles
                values["detail"] = infoList[i].details
                newRef.updateChildValues(values)
            }
        }
        
        
        
        if let rootVC = navigationController?.viewControllers[0] as? CompanyProfileViewController {
            if let tabNum = currentTabNumber, let indexPath = currentIndexPath {
                rootVC.company?.infoList[tabNum] = infoList
                rootVC.tableView.reloadData()
                navigationController?.popViewController(animated: true)
            }
        }
        
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return infoList.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.bounds.width, height: 56)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptionViewId, for: indexPath) as! UserDescriptionCollectionViewCell

        if indexPath.row == 0 {
            cell.titleLabel.text = "title"
            cell.textLabel.text = infoList[indexPath.section].titles
        } else if indexPath.row == 1 {
            cell.titleLabel.text = "detail"
            cell.textLabel.text = infoList[indexPath.section].details
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let editVC = EditCompanyDescriptionController()
        
        var currentData: String? = ""
        
        if indexPath.row == 0 {
            currentData = infoList[indexPath.section].titles
        } else if indexPath.row == 1 {
            currentData = infoList[indexPath.section].details
        }
        
        editVC.currentCompanyDescription = currentData
        editVC.currentIndexPath = indexPath
        editVC.currentInfo = infoList[indexPath.section]
        navigationController?.pushViewController(editVC, animated: true)
        
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: descriptionViewHeaderId, for: indexPath) as! EditCollectionViewHeaderCell
        if let title = infoList[0].type?.rawValue {
            headerView.titleLabel.text = "\(title) \(indexPath.section+1)"
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 1 {
            if let text = infoList[indexPath.section] .details{
                let estimatedHeight = estimateFrame(for: text).height + 50
                return CGSize(width: collectionView.bounds.width, height: estimatedHeight)
            }
            return CGSize(width: collectionView.bounds.width, height: 77)
        }
        return CGSize(width: collectionView.bounds.width, height: 77)
        
    }
    
    private func estimateFrame(for text: String) -> CGRect {
        let size = CGSize(width: 300, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .regular)], context: nil)
    }
    
}

