//
//  CompanyProfileViewController.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/04.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit
import Firebase

final class CompanyProfileViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, TableDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var isHeaderImageEditing = false
    private var isProfileImageEditing = false

    var isStudent: Bool?
    var isApplying = false
    var company: Company?
    
    var currentTabNumber = 0
    var companyHeaderId = "companyHeaderId"
    var companyDescriptionId = "companyDescriptionId"
    var buttonCellId = "buttonCellId"
    var companyDescriptionViewId = "companyDescriptionViewId"
    let cellId = "cellId"
    
    var currentDescriptionViewData: [CompanyInfo] {
        get {
            return company?.infoList[currentTabNumber] ?? []
        }
    }
    
    private func checkIsApplying() -> Bool? {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("couldn't get uid")
            return nil
        }
        
        if let companyId = company?.id {
            let ref = Database.database().reference().child("user-apply").child(companyId)
            ref.observe(.childAdded, with: { [weak self] (snapshot) in
                if snapshot.key == uid {
                    self?.isApplying = true
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    return
                }
            }, withCancel: nil)
        }
        return true
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
        tableView.backgroundColor = .white
        if !isStudent! {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        }
        fetchCompanyData()
        checkIsApplying()
        
    }
    
    @objc private func handleLogout(){
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
            return
        }
        
        let loginVC = RegisterController()
        present(loginVC, animated: true, completion: nil)
    }
    
    private func setupEditButton(with cell: CompanyDescriptionTableViewCell) {
        if isStudent! {
            cell.editButton.isHidden = true
            cell.editButton.isEnabled = false
        } else {
            cell.editButton.isHidden = false
            cell.editButton.isEnabled = true
            cell.editButton.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
        }
    }
    
    func handleSetupHeaderImage() {
        isHeaderImageEditing = true
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true)
    }
    
    func handleSetupProfileImage() {
        isProfileImageEditing = true
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        var selectedImage : UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImage = editedImage
        } else {
            selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        }
        
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? CompanyHeaderCell {
            if let profileImage = selectedImage, let imageData = UIImageJPEGRepresentation(profileImage, 0.1) {
                let imageName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("profile-images").child("\(imageName).jpg")
                storageRef.putData(imageData, metadata: nil, completion: { [weak self] (metadata, err) in
                    
                    if err != nil {
                        print(err!)
                        return
                    }
                    
                    if let imageUrlString = metadata?.downloadURL()?.absoluteString {
                        var values = [String:String]()
                        
                        if (self?.isProfileImageEditing)! {
                            values = ["profileImageUrl": imageUrlString]
                            self?.company?.profileImageUrl = imageUrlString
                        } else if (self?.isHeaderImageEditing)! {
                            values = ["headerImageUrl": imageUrlString]
                            self?.company?.headerImageUrlStr = imageUrlString
                        }
                        
                        
                        let ref = Database.database().reference().child("users").child("company").child(uid)
                        ref.updateChildValues(values)
                        
                        
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                        
                        self?.isProfileImageEditing = false
                        self?.isHeaderImageEditing = false
                    }
                })
            }
        }
        dismiss(animated: true, completion: nil)
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

            let layout = UICollectionViewFlowLayout()
            let companyEditC = CompanyEditController(collectionViewLayout: layout)
            companyEditC.infoList = currentDescriptionViewData
            companyEditC.currentTabNumber = currentTabNumber
            companyEditC.currentIndexPath = indexPath
            navigationController?.pushViewController(companyEditC, animated: true)
        }
    }

    func fetchCompanyData() {
        if !isStudent! {
            guard let uid = Auth.auth().currentUser?.uid else {
                print("couldn't get uid")
                return
            }
            let ref = Database.database().reference().child("users").child("company").child(uid)
            ref.observeSingleEvent(of: .value) { [weak self] (snapshot) in

                if let dictionary = snapshot.value as? [String : AnyObject] {
                    self?.company = Company(dictionary: dictionary)
                }
                
                self?.company?.id = snapshot.key
                
                
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else  {
            print("couldn't find uid")
            return
        }
        
        if let company = company {
            if currentDescriptionViewData.count > 1 {
                if let type = currentDescriptionViewData[0].type?.rawValue {
                    let ref = Database.database().reference().child("users").child("company").child(uid).child(type)
                    ref.observeSingleEvent(of: .value, with: { (snapshot) in
                        if let dict = snapshot.value as? [String: AnyObject] {
                            let keys = Array(dict.keys).sorted(by: <)
                            let key = keys[indexPath.row]
                            let deleteRef = ref.child(key)
                            deleteRef.removeValue{ [weak self] (err, companyRef) in
                                if let err = err {
                                    print(err)
                                    return
                                }
                                DispatchQueue.main.async {
                                    self?.fetchCompanyData()
                                }
                            }
                        }
                    }, withCancel: nil)
                }
            } else {
                //sending alert
            }
        }
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return isStudent! ? 2 : 1
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
                cell.editButton.addTarget(self, action: #selector(handleEditHeaderInfo), for: .touchUpInside)
                cell.delegate = self
                cell.editButton.isUserInteractionEnabled = isStudent! ? false : true
                cell.editButton.isHidden = isStudent! ? true : false
                cell.profileImageView.isUserInteractionEnabled = isStudent! ? false : true
                cell.headerImageView.isUserInteractionEnabled = isStudent! ? false : true
                if let name = company?.name, let profileImageUrlStr = company?.profileImageUrl, let headerImageUrlStr  = company?.headerImageUrlStr {
                    cell.companyNameLabel.text = name
                    cell.companyPlaceLabel.text = company?.place
                    cell.companyIndustryLabel.text = company?.domain
                    cell.profileImageView.loadImageWithCache(with: profileImageUrlStr)
                    cell.headerImageView.loadImageWithCache(with: headerImageUrlStr)
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: buttonCellId, for: indexPath) as! ButtonTableViewCell
                cell.cellButton.addTarget(self, action: #selector(handleApply), for: .touchUpInside)
                cell.cellButton.setTitle("Apply", for: .normal)
                cell.cellButton.setTitleColor(.white, for: .normal)
                if isApplying {
                    cell.cellButton.backgroundColor = .lightGray
                    cell.cellButton.setTitle("Applied", for: .normal)
                    cell.cellButton.isEnabled = false
                }
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
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Couldn't get uid")
            return
        }
        
        sender.backgroundColor = UIColor.applyButtonHighlightedGreen
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { [weak self] (timer) in
            sender.backgroundColor = UIColor.applyButtonGreen
            self?.isApplying = true
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
            timer.invalidate()
        }
        if let companyId = company?.id {
            let ref = Database.database().reference().child("user-apply").child(companyId)
            ref.updateChildValues([uid: 1])
        }
    }
    
    @objc private func handleEditHeaderInfo() {
        let layout = UICollectionViewFlowLayout()
        let editVC = CompanyHeaderEditController(collectionViewLayout: layout)
        editVC.company = company
        navigationController?.pushViewController(editVC, animated: true)
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
        cv.register(CustomNavBarCell.self, forCellWithReuseIdentifier: cellId)
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


