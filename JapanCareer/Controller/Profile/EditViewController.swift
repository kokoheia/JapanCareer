//
//  EditViewController.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/13.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UITextFieldDelegate {
    
    var currentCard: ProfileCard?
    var currentRowNumber: Int?
    
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
        let rootController = navigationController?.viewControllers[1] as! ProfileEditCollectionViewController
        let cardList = rootController.cardList
        for card in cardList {
            if card == currentCard {
                
                if let newText = textInput.text {
                    updateCard(card: card, number: currentRowNumber!, text: newText)
                }
                rootController.collectionView?.reloadData()
                navigationController?.popViewController(animated: true)
            }
        }
    }
    private func updateCard(card: ProfileCard, number: Int, text: String) {
        switch number {
        case 0:
            card.title = text
        case 1:
            card.detailTitle = text
        case 2:
            card.startTime = text
        case 3:
            card.endTime = text
        default:
            return
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


