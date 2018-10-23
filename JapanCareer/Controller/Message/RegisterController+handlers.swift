//
//  LoginController+handlers.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/03/31.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit
import Firebase

extension RegisterController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handlePickUpImage() {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImage : UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImage = editedImage
        } else {
            selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        }
        imageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleRegister() {
        present(userConfirmAlert, animated: true, completion: nil)
    }
    
    private func registerUser() {
        guard let name = nameInput.textInput.text,  let email = emailInput.textInput.text, let password = passwordInput.textInput.text, !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            present(blankAlert, animated: true, completion: nil)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, err) in
            if err != nil {
                print(err!)
                if let alert = self?.invalidEmailAlert {
                    self?.present(alert, animated: true, completion: nil)
                }
                return
            }
            guard let uid = user?.uid else {
                print("couldn't catch uid")
                return
            }
            
            guard let fcmToken = Messaging.messaging().fcmToken else {
                return
            }
            if let profileImage = self?.imageView.image, let imageData = UIImageJPEGRepresentation(profileImage, 0.1) {
                let imageName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("profile-images").child("\(imageName).jpg")
                storageRef.putData(imageData, metadata: nil, completion: { [weak self] (metadata, err) in
                    
                    if let profileImageUrlString = metadata?.downloadURL()?.absoluteString {
                        var values = [String: String]()
                        
                        if (self?.isStudent)! {
                            values = ["name": name, "email": email, "profileImageUrl": profileImageUrlString, "fcmToken": fcmToken]
                        } else {
                            values = ["name": name, "email": email, "profileImageUrl": profileImageUrlString, "headerImageUrl" : profileImageUrlString, "fcmToken": fcmToken]
                        }
                        
                        if err != nil {
                            print(err!)
                            return
                        }
                        self?.registerUserIntoDatabase(with: uid, values: values as [String : AnyObject])
                    }
                })
            }
        }

    }
    
    private func registerUserIntoDatabase(with uid: String, values: [String: AnyObject]) {
        let userType = self.isStudent ? "student" : "company"
        let ref =  Database.database().reference().child("users").child(userType).child(uid)
        ref.updateChildValues(values, withCompletionBlock: { [weak self] (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
//            self?.messageController?.navigationItem.title = values["name"] as? String
//            self?.messageController?.isStudent = self?.isStudent
            
            if let presentingVC = self?.presentingViewController as? CustomTabBarController {
                presentingVC.isStudent = self?.isStudent
                presentingVC.selectedIndex = 2
                presentingVC.refreshUser()
             } else {
                print("couldn't down cast custom tab bar controller")
            }
            self?.dismiss(animated: true, completion: nil)
        })
    }
}


extension RegisterController {
    
    var blankAlert: UIAlertController {
        let alert = UIAlertController(title: "Coundn't register your account", message: "Please fill in all the blanks.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
        return alert
    }
    
    var invalidEmailAlert: UIAlertController {
        let alert = UIAlertController(title: "Coundn't register your account", message: "Invalid email address.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
        return alert
    }
    
    var userConfirmAlert: UIAlertController {
        let userString = isStudent ? "student" : "company"
        let alert = UIAlertController(title: "Are you sure you are a \(userString)?", message: "If you are \(userString) please tap Yes.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] (confirmed) in
            self?.registerUser()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        return alert
    }
}
