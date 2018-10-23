//
//  EditCompanyDescription.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/17.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit
import Firebase

final class EditCompanyDescriptionController: UIViewController, UITextViewDelegate {
    
    var currentIndexPath: IndexPath?
    var currentInfo: CompanyInfo?    
    var currentCompanyDescription: String?
    
    lazy var textInput: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .right
        textField.delegate = self
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.layer.borderWidth  = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.textAlignment = .left
        return textField
    }()
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            DispatchQueue.main.async {
                self.view.layoutIfNeeded()
            }
            return false
        }
        return true
    }
    
    
    private var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.myGrayColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func titleString(indexPath: IndexPath) -> String{
        if indexPath.row == 0 {
            return "Title"
        } else {
            return "Detail"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDone))
        if let indexPath = currentIndexPath {
            navigationItem.title = titleString(indexPath: indexPath)
        }
        setupView()
        
        textInputHeightConstraint?.constant = estimatedFrame(for: textInput.text).height + 50
        
        if textInputHeightConstraint != nil, textInputHeightConstraint!.constant > 250 {
            textInputHeightConstraint?.constant = 250
        }
        
    
    }

    
    @objc private func handleDone() {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            print("couldn't get current user")
//            return
//        }
//
//        let ref = Database.database().reference().child("users").child("company").child(uid).child(currentInfo!.type!.rawValue)
//        let titleString = currentInfo
//        
//        let values = [:]
//        
//        ref.updateChildValues(<#T##values: [AnyHashable : Any]##[AnyHashable : Any]#>)
        
        
        if let rootController = navigationController?.viewControllers[1] as? CompanyEditController {
//            let currentData = rootController.currentDescriptionViewData
            
            if let indexPath = currentIndexPath {
                if currentIndexPath?.row == 0 {
                    rootController.infoList[indexPath.section].titles = textInput.text

                } else if currentIndexPath?.row == 1 {
                    rootController.infoList[indexPath.section].details = textInput.text
                    
                }
                rootController.collectionView?.reloadItems(at: [indexPath])
            }
         
            
//
//
//            if let type = currentData.type {
//                let typeStr = type.rawValue
//                let value = ["title": , "detail": textInput.text]
//            }
//
//
            
//            if let indexPath = currentIndexPath {
//                currentData.details![indexPath.row] =  textInput.text
//
//            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func estimatedFrame(for text: String) -> CGRect {
        let size = CGSize(width: 337, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15, weight: .regular)], context: nil)
    }
    
    

    var textInputHeightConstraint: NSLayoutConstraint?
    
    private func setupView() {
        
        self.textInput.text = currentCompanyDescription
       
        view.addSubview(textInput)
        textInput.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textInput.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        textInput.widthAnchor.constraint(equalToConstant: 337).isActive = true
        textInputHeightConstraint = textInput.heightAnchor.constraint(equalToConstant: 200)
        textInputHeightConstraint?.isActive = true
    }
    
}


