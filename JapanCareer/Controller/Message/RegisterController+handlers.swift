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
        guard let name = nameInput.textInput.text,  let email = emailInput.textInput.text, let password = passwordInput.textInput.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if err != nil {
                print(err!)
                return
            }
            
            guard let uid = user?.uid else {
                print("couldn't catch uid")
                return
            }
            if let profileImage = self.imageView.image, let imageData = UIImageJPEGRepresentation(profileImage, 0.1) {
                let imageName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("profile-images").child("\(imageName).jpg")
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, err) in
                    
                    if let profileImageUrlString = metadata?.downloadURL()?.absoluteString {
                        
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrlString]
                        
                        if err != nil {
                            print(err!)
                            return
                        }
                        self.registerUserIntoDatabase(with: uid, values: values as [String : AnyObject])
                    }

                })
                
            }

        }
    }
    
    private func registerUserIntoDatabase(with uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference().child("users").child(uid)
        
        ref.updateChildValues(values, withCompletionBlock: { [weak self] (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
            self?.messageController?.navigationItem.title = values["name"] as? String
            self?.dismiss(animated: true, completion: nil)
        })
        
    }
    
}
