//
//  EditViewController.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/13.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit
import Firebase

class EditViewController: UIViewController, UITextFieldDelegate {
    
    var isStudent: Bool?
    
    var currentCard: ProfileCard?
    var currentRowNumber: Int?
    var currentTitle: String?
    
    
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
        navigationItem.title = currentTitle
        setupView()
    }
    
    @objc private func handleDone() {
        
        guard let text = textInput.text, !text.isEmpty else {
            print("Invalid edit")
            present(emptyAlert, animated: true, completion: nil)
            return
        }
        
        if currentRowNumber == 2 || currentRowNumber == 3 {
            if !checkYearFormat(of: text) {
                return
            }
        }
        
        if let rootController = navigationController?.viewControllers[1] as? ProfileEditCollectionViewController {
            var cardList = rootController.cardList
            for index in cardList.indices {
                if cardList[index] == currentCard {
                    updateCard(card: cardList[index], number: currentRowNumber!, text: text)
                    rootController.collectionView?.reloadData()
                    navigationController?.popViewController(animated: true)
                }
            }
            
        } else if let rootController = navigationController?.viewControllers[0] as? ProfileController {
            guard let uid = Auth.auth().currentUser?.uid else {
                print("Couldn't get the uid")
                return
            }
            // if the header is edited
            if let text = textInput.text {
                let userType = self.isStudent! ? "student" : "company"
                let ref = Database.database().reference().child("users").child(userType).child(uid)
                let value = ["name" : text]
                ref.updateChildValues(value)
                rootController.user?.name = text
                DispatchQueue.main.async { [weak self] in
                    rootController.tableView.reloadData()
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            
        } else {
            print("error")
        }
    }
    
    
    private func checkYearFormat(of text: String) -> Bool {
        return true
        
//        if currentRowNumber == 2 {
//            let startStr = text.split(separator: ".")
//            if let endStr = currentCard?.endTimestamp?.split(separator: ".") {
//                if !checkMonth(yearMonth: startStr) {
//                    present(wrongMonthAlert, animated: true, completion: { [weak self] in
//                        self?.textInput.text = ""
//                    })
//                    return false
//                }
//
//                if !checkYearMonth(startList: startStr, endList: endStr) {
//                    present(timingAlert, animated: true, completion: { [weak self] in
//                        self?.textInput.text = ""
//                    })
//                    return false
//
//
//                }
//            }
//        } else if currentRowNumber == 3 {
//            let endStr = text.split(separator: ".")
//            if let startStr = currentCard?.endTimestamp?.split(separator: ".") {
//                if !checkMonth(yearMonth: endStr) {
//                    present(wrongMonthAlert, animated: true, completion: { [weak self] in
//                        self?.textInput.text = ""
//                    })
//                    return false
//
//                }
//
//                if !checkYearMonth(startList: startStr, endList: endStr) {
//                    present(timingAlert, animated: true, completion: { [weak self] in
//                        self?.textInput.text = ""
//                    })
//                    return false
//                }
//            }
//        }
//
//        if !matchExists(for: "\\d{4}\\.[1-9]+", in: text) {
//            present(formatAlert, animated: true, completion: { [weak self] in
//                self?.textInput.text = ""
//            })
//            return false
//        }
//        return true
    }
    
    
    private func checkMonth(yearMonth: [String.SubSequence]) -> Bool {
        if yearMonth.count != 2{
            return false
        }
        if yearMonth[1].count == 2 {
            if let intMonth = Int(yearMonth[1]) {
                if intMonth > 12 {
                    return false
                }
            }
        }
        return true
    }
    
    private func checkYearMonth(startList: [String.SubSequence], endList: [String.SubSequence]) -> Bool{
        if startList.count == 2 && endList.count == 2 {
            if let startYear = Int(startList[0]), let endYear =  Int(endList[0]), let startMonth = Int(startList[1]), let endMonth = Int(endList[1]) {
                if startYear > endYear {
                    return false
                } else if startYear == endYear && startMonth > endMonth {
                    return false
                }
            }
        }
        return true
    }
    
    //code from http://jayeshkawli.ghost.io/regular-expressions-in-swift-ios/
    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            let finalResult = results.map {
                String(text[Range($0.range, in: text)!])
            }
            return finalResult
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func matchExists(for regex: String, in text: String) -> Bool {
        return matches(for: regex, in: text).count > 0
    }
    
    
    private func updateCard(card: ProfileCard, number: Int, text: String) {
//        let backupCard = card.copy() as! ProfileCard
        switch number {
        case 0:
            card.title = text
        case 1:
            card.detailTitle = text
        default:
            return
        }
        // check if there is a duplication
        if let rootController = navigationController?.viewControllers[1] as? ProfileEditCollectionViewController {
            var cardList = rootController.cardList
            var duplicateCount = 0
            for index in cardList.indices {
                if cardList[index] == card {
                    duplicateCount += 1
                }
                if duplicateCount >= 2 {
                    print("You can't make same card")
                    card.title = nil
                    card.detailTitle = nil
                    card.startTimestamp = nil
                    card.endTimestamp = nil
                }
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


extension EditViewController {
    var emptyAlert: UIAlertController {
        let alert = UIAlertController(title: "Invalid Form", message: "Please fill the blank.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
        return alert
    }
    
    var formatAlert: UIAlertController {
        let alert = UIAlertController(title: "Invalid Form", message: "Please fill the same way as example.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
        return alert
    }
    
    var timingAlert: UIAlertController {
        let alert = UIAlertController(title: "Invalid Form", message: "Start timing is later than end timing.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
        return alert
    }
    
    var wrongMonthAlert: UIAlertController {
        let alert = UIAlertController(title: "Invalid Form", message: "This year/month is invalid.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
        return alert
    }
}

