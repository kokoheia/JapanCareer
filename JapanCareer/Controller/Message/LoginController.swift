//
//  LoginController.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/03/30.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
        
    private var backgroundImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "shrine")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var backgroundFilter: UIView = {
        var filterView = UIView()
        filterView.backgroundColor = UIColor.myGrayColor
        filterView.translatesAutoresizingMaskIntoConstraints = false
        return filterView
    }()
    
    private var backButton: ButtonWithImage = {
        var button = ButtonWithImage()
        button.title.text = "Back"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var titleText: UILabel = {
        var tv = UILabel()
        tv.text = "Log in" 
        tv.textColor = .white
        tv.font = UIFont.systemFont(ofSize: 24, weight: .light)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private var emailInput: LoginInputCell = {
        var inputView = LoginInputCell()
        inputView.titleLabel.text = "Email"
        inputView.imageIcon.image = UIImage(named: "email")
        inputView.translatesAutoresizingMaskIntoConstraints = false
        return inputView
    }()
    
    private var passwordInput: LoginInputCell = {
        var inputView = LoginInputCell()
        inputView.titleLabel.text = "Password"
        inputView.imageIcon.image = UIImage(named: "password")
        inputView.textInput.isSecureTextEntry = true
        inputView.translatesAutoresizingMaskIntoConstraints = false
        return inputView
    }()
    
    private lazy var registerButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.mainColor
        button.setTitle("Log in", for: .normal)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleLogin() {
        guard let email = emailInput.textInput.text, let password = passwordInput.textInput.text, !email.isEmpty, !password.isEmpty else {
            print("Form is not valid")
            self.present(blankAlert, animated: true, completion: nil)
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, err) in
            if err != nil {
                print(err!)
                if let alert = self?.missingUserAlert {
                    self?.present(alert, animated: true, completion: nil)
                    return
                }
            }
            if let uid = user?.uid {
                let ref = Database.database().reference().child("users")
                let studentRef = ref.child("student")
                studentRef.observe(.childAdded, with: { [weak self] (snapshot) in
                    if snapshot.key == uid {
                        let customTabBarC = CustomTabBarController()
                        customTabBarC.isStudent = true
                        self?.present(customTabBarC, animated: true, completion: nil)
                        return
                    }
                }, withCancel: nil)
                
                let companyRef = ref.child("company")
                companyRef.observe(.childAdded, with: { (snapshot) in
                    if snapshot.key == uid {
                        let customTabBarC = CustomTabBarController()
                        customTabBarC.isStudent = false
                        self?.present(customTabBarC, animated: true, completion: nil)
                        return
                    }
                }, withCancel: nil)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view?.backgroundColor = .white
        setupBackgroundImageView()
        setupBackgroundFilter()
        setupTextView()
        setupInputFields()
        setupButton()
        setupBackButton()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleBack))
        backButton.addGestureRecognizer(tap)
        
        let resignTap = UITapGestureRecognizer(target: self, action: #selector(handleResign))
        view.addGestureRecognizer(resignTap)
    }
    
    @objc func handleResign() {
        emailInput.textInput.resignFirstResponder()
        passwordInput.textInput.resignFirstResponder()
    }
    
    @objc func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    

    private func setupBackButton() {
        view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 9).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 38).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func setupTextView() {
        view.addSubview(titleText)
        
        if UIDevice.current.modelName == "iPhone 5s" || UIDevice.current.modelName == "iPhone6,1" {
            titleText.font = UIFont.systemFont(ofSize: 20, weight: .light)
        }
        
        titleText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleText.topAnchor.constraint(equalTo: view.topAnchor, constant: 152).isActive = true
    }
    
    private func setupBackgroundImageView() {
        view.addSubview(backgroundImageView)
        backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    private func setupBackgroundFilter() {
        view.addSubview(backgroundFilter)
        backgroundFilter.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundFilter.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundFilter.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundFilter.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    private func setupInputFields() {
        view.addSubview(emailInput)
        view.addSubview(passwordInput)
        
        if UIDevice.current.modelName == "iPhone 5s" || UIDevice.current.modelName == "iPhone6,1" {
            let fontConstant: CGFloat  = 15
            emailInput.textInput.font = UIFont.systemFont(ofSize: fontConstant, weight: .regular)
            emailInput.titleLabel.font = UIFont.systemFont(ofSize: fontConstant, weight: .regular)
            passwordInput.textInput.font = UIFont.systemFont(ofSize: fontConstant, weight: .regular)
            passwordInput.titleLabel.font = UIFont.systemFont(ofSize: fontConstant, weight: .regular)
            
            emailInput.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            emailInput.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -45).isActive = true
            emailInput.widthAnchor.constraint(equalToConstant: 351).isActive = true
            emailInput.heightAnchor.constraint(equalToConstant: 35).isActive = true

            passwordInput.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            passwordInput.topAnchor.constraint(equalTo: emailInput.bottomAnchor, constant: 37).isActive = true
            passwordInput.widthAnchor.constraint(equalToConstant: 351).isActive = true
            passwordInput.heightAnchor.constraint(equalToConstant: 35).isActive = true
            return
        }
        
        
        emailInput.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        emailInput.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emailInput.widthAnchor.constraint(equalToConstant: 351).isActive = true
        emailInput.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        passwordInput.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        passwordInput.topAnchor.constraint(equalTo: emailInput.bottomAnchor, constant: 37).isActive = true
        passwordInput.widthAnchor.constraint(equalToConstant: 351).isActive = true
        passwordInput.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
    }
    
    private func setupButton() {
        view.addSubview(registerButton)
        
        if UIDevice.current.modelName == "iPhone 5s" || UIDevice.current.modelName == "iPhone6,1" {
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            registerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -127).isActive = true
            registerButton.widthAnchor.constraint(equalToConstant: 271).isActive = true
            registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            return
        }
        
        
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -159).isActive = true
        registerButton.widthAnchor.constraint(equalToConstant: 271).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
}

extension LoginController {
    var blankAlert: UIAlertController {
        let alert = UIAlertController(title: "Coundn't Log in", message: "Please fill in all the blanks.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
        return alert
    }
    
    var missingUserAlert: UIAlertController {
        let alert = UIAlertController(title: "Coundn't Log in", message: "The email or password you entered is incorrect", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
        return alert
    }
}
