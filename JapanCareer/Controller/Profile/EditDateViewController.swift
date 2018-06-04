//
//  EditDateViewController.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/05/08.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//


import UIKit
import Firebase

class EditDateViewController: UIViewController, UITextFieldDelegate {
    
    var isStudent: Bool?
    
    var currentCard: ProfileCard?
    var currentRowNumber: Int?
    var currentTitle: String?
    
    var currentCompanyDescription: String?
    
    var startTimestamp: NSNumber?
    var endTimestamp: NSNumber?
    
    
    private var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(handleDatePicking), for: .valueChanged)
        return picker
    }()
    
    lazy var textInput: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .right
        textField.delegate = self
        textField.inputView = datePicker
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleFinishEdit))
        view.addGestureRecognizer(tap)
        setupView()
    }
    
    @objc private func handleFinishEdit() {
        view.endEditing(true)
    }
    
    
    @objc private func handleDatePicking(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.M.d"
        if currentRowNumber! == 2 {
            startTimestamp = Int(sender.date.timeIntervalSince1970) as NSNumber
        } else {
            endTimestamp = Int(sender.date.timeIntervalSince1970) as NSNumber
        }
        
        textInput.text = dateFormatter.string(from: sender.date)
        view.endEditing(true)
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
                    
                    var timestamp = NSNumber()
                    if currentRowNumber! == 2 {
                        if let startTime = startTimestamp {
                            timestamp = startTime
                        }
                    } else if currentRowNumber! == 3 {
                        if let endTime = endTimestamp {
                            timestamp = endTime
                        }
                    }
                    updateCard(card: cardList[index], rowNumber: currentRowNumber!, timestamp: timestamp)
                    rootController.collectionView?.reloadData()
                    
                    navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    
    private func checkYearFormat(of text: String) -> Bool {
        if let startTime = startTimestamp, let endTime = endTimestamp {
            if startTime.transformToDate() > endTime.transformToDate() {
                present(timingAlert, animated: true, completion: { [weak self] in
                    self?.textInput.text = ""
                })
                return false
            }
        }
        return true
    }


    
    //code from http://jayeshkawli.ghost.io/regular-expressions-in-swift-ios/
//    func matches(for regex: String, in text: String) -> [String] {
//        do {
//            let regex = try NSRegularExpression(pattern: regex)
//            let results = regex.matches(in: text,
//                                        range: NSRange(text.startIndex..., in: text))
//            let finalResult = results.map {
//                String(text[Range($0.range, in: text)!])
//            }
//            return finalResult
//        } catch let error {
//            print("invalid regex: \(error.localizedDescription)")
//            return []
//        }
//    }
//
//    func matchExists(for regex: String, in text: String) -> Bool {
//        return matches(for: regex, in: text).count > 0
//    }
//
    
    private func updateCard(card: ProfileCard, rowNumber: Int, timestamp: NSNumber) {
        switch rowNumber {
            case 2:
                card.startTimestamp = timestamp
            case 3:
                card.endTimestamp = timestamp
            default:
                return
        }
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
//        //        let backupCard = card.copy() as! ProfileCard
//        switch number {
//        case 0:
//            card.title = text
//        case 1:
//            card.detailTitle = text
//        case 2:
//            card.startTime = text
//        case 3:
//            card.endTime = text
//        default:
//            return
//        }
//        // check if there is a duplication
//        if let rootController = navigationController?.viewControllers[1] as? ProfileEditCollectionViewController {
//            var cardList = rootController.cardList
//            var duplicateCount = 0
//            for index in cardList.indices {
//                if cardList[index] == card {
//                    duplicateCount += 1
//                }
//                if duplicateCount >= 2 {
//                    print("You can't make same card")
//                    card.title = nil
//                    card.detailTitle = nil
//                    card.startTime = nil
//                    card.endTime = nil
//                }
//            }
//        }
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


//extension EditDateViewController {
//    var emptyAlert: UIAlertController {
//        let alert = UIAlertController(title: "Invalid Form", message: "Please fill the blank.", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
//        return alert
//    }
//
//    var formatAlert: UIAlertController {
//        let alert = UIAlertController(title: "Invalid Form", message: "Please fill the same way as example.", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
//        return alert
//    }
//
//    var timingAlert: UIAlertController {
//        let alert = UIAlertController(title: "Invalid Form", message: "Start timing is later than end timing.", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
//        return alert
//    }
//
//    var wrongMonthAlert: UIAlertController {
//        let alert = UIAlertController(title: "Invalid Form", message: "This year/month is invalid.", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
//        return alert
//    }
//}
//

extension EditDateViewController {

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

