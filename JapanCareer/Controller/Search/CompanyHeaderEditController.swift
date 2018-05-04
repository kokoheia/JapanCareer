//
//  CompanyHeaderEditController.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/05/03.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit
import Firebase

class CompanyHeaderEditController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var company: Company?
    
    private let descriptionViewId = "descriptionViewId"
    private let descriptionViewHeaderId = "descriptionViewHeaderId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        collectionView?.register(UserDescriptionCollectionViewCell.self, forCellWithReuseIdentifier: descriptionViewId)
        collectionView?.backgroundColor = .white
    }
    
    private func setupNavigationBar() {
        let saveBarButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        navigationItem.rightBarButtonItems = [saveBarButton]
        navigationItem.title = "Edit Profile"
        
    }

    
    @objc private func handleSave() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("couldn't get current user")
            return
        }
        
        let ref = Database.database().reference().child("users").child("company").child(uid)
        
        if let name = company?.name, let place = company?.place, let domain = company?.domain {
            let values = ["name": name, "place": place, "domain": domain]
            ref.updateChildValues(values)
        }

        if let rootVC = navigationController?.viewControllers[0] as? CompanyProfileViewController {
            DispatchQueue.main.async { [weak self] in
                rootVC.tableView.reloadData()
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptionViewId, for: indexPath) as! UserDescriptionCollectionViewCell
        
        if let comp = company {
            if indexPath.row == 0 {
                cell.titleLabel.text = "name"
                cell.textLabel.text = comp.name
            } else if indexPath.row == 1 {
                cell.titleLabel.text = "place"
                cell.textLabel.text = comp.place ?? ""
            } else if indexPath.row == 2{
                cell.titleLabel.text = "domain"
                cell.textLabel.text = comp.domain ?? ""
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let editVC = EditCompanyHeaderViewController()
        editVC.company = company
        editVC.currentIndexPath = indexPath
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.bounds.width, height: 77)
        
    }
    
}

