//
//  EditCompanyHeaderViewController.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/05/03.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit
import Firebase

class EditCompanyHeaderViewController: UIViewController, UITextFieldDelegate {
    
    var company: Company?
    
    var currentIndexPath: IndexPath?
    
    var currentCompanyDescription: String?
    
    lazy var textInput: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .right
        textField.delegate = self
        return textField
    }()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    private var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.myGrayColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDone))
        setupView()
    }
    
    @objc private func handleDone() {
        if let row = currentIndexPath?.row {
            switch row {
            case 0:
                company?.name = textInput.text
            case 1:
                company?.place = textInput.text
            case 2:
                company?.domain = textInput.text
            default:
                return
            }
        }
        
        if let rootController = navigationController?.viewControllers[1] as? CompanyHeaderEditController {
            rootController.company = company
            DispatchQueue.main.async { [weak self] in
                rootController.collectionView?.reloadData()
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    private func setupView() {
        view.addSubview(separatorView)
        separatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        separatorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 85).isActive = true
        separatorView.widthAnchor.constraint(equalToConstant: 337).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(textInput)
        textInput.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        textInput.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: -10).isActive = true
        textInput.widthAnchor.constraint(equalTo: separatorView.widthAnchor).isActive = true
    }
    
}


