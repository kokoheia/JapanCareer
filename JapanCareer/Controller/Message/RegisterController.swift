//
//  LoginViewController.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/03/29.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit
import Firebase

class RegisterController: UIViewController {
    
    var isStudent: Bool {
        return studentCompanySegmentedControl.selectedSegmentIndex == 0 ? true : false
    }
    
    var messageController : MessageController?
    
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
    
    private var titleText: UILabel = {
        var tv = UILabel()
        tv.text = "Welcome to J Career."
        tv.textColor = .white
        tv.font = UIFont.systemFont(ofSize: 24, weight: .light)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    var nameInput: LoginInputCell = {
        var inputView = LoginInputCell()
        inputView.textInput.text = nil
        inputView.titleLabel.text = "Name"
        inputView.imageIcon.image = UIImage(named: "account")
        inputView.translatesAutoresizingMaskIntoConstraints = false
        return inputView
    }()
    
    var emailInput: LoginInputCell = {
        var inputView = LoginInputCell()
        inputView.textInput.text = nil
        inputView.titleLabel.text = "Email"
        inputView.imageIcon.image = UIImage(named: "email")
        inputView.translatesAutoresizingMaskIntoConstraints = false
        return inputView
    }()
    
    var passwordInput: LoginInputCell = {
        var inputView = LoginInputCell()
        inputView.textInput.text = nil
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
        button.setTitle("Register", for: .normal)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    
    private var signInBar: UIView = {
        var bar = UIView()
        bar.backgroundColor = UIColor.darkBlueColor
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    private var textLabel: UILabel = {
        var label = UILabel()
        label.text = "If you already have an account, sign in"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var signInLink: UIButton = {
        var button = UIButton()
        var attributedText = NSAttributedString(string: "here",
            attributes:
            [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16, weight: .bold),
             NSAttributedStringKey.foregroundColor : UIColor.white]
        )
        button.setAttributedTitle(attributedText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "origami-white")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePickUpImage))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    var studentCompanySegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Student", "Company"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = .white
        sc.selectedSegmentIndex = 0
        return sc
    }()

    
    @objc private func handleShowLogin() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view?.backgroundColor = .white
        setupBackgroundImageView()
        setupBackgroundFilter()
        setupInputFields()
        setupButton()
        setupSignInBar()
        setupSegmentedControl()
        setupImageView()
        
        let resignTap = UITapGestureRecognizer(target: self, action: #selector(handleResign))
        view.addGestureRecognizer(resignTap)
    }
    
    @objc func handleResign() {
        
        
        nameInput.textInput.resignFirstResponder()
        emailInput.textInput.resignFirstResponder()
        passwordInput.textInput.resignFirstResponder()
    }
    
    private func setupSegmentedControl() {
        view.addSubview(studentCompanySegmentedControl)
        
        if UIDevice.current.modelName == "iPhone 5s" || UIDevice.current.modelName == "iPhone6,1" {
            studentCompanySegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            studentCompanySegmentedControl.bottomAnchor.constraint(equalTo: nameInput.topAnchor, constant: -15).isActive = true
            studentCompanySegmentedControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
            studentCompanySegmentedControl.heightAnchor.constraint(equalToConstant: 24).isActive = true
            return
        }
        
        studentCompanySegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        studentCompanySegmentedControl.bottomAnchor.constraint(equalTo: nameInput.topAnchor, constant: -35).isActive = true
        studentCompanySegmentedControl.widthAnchor.constraint(equalToConstant: 244).isActive = true
        studentCompanySegmentedControl.heightAnchor.constraint(equalToConstant: 29).isActive = true
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        
        if UIDevice.current.modelName == "iPhone 5s" || UIDevice.current.modelName == "iPhone6,1" {
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: studentCompanySegmentedControl.topAnchor, constant: -14).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
            return
        }
        
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: studentCompanySegmentedControl.topAnchor, constant: -24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
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
        view.addSubview(nameInput)
        view.addSubview(emailInput)
        view.addSubview(passwordInput)
        
        if UIDevice.current.modelName == "iPhone 5s" || UIDevice.current.modelName == "iPhone6,1" {
            let fontConstant: CGFloat  = 15
            emailInput.textInput.font = UIFont.systemFont(ofSize: fontConstant, weight: .regular)
            emailInput.titleLabel.font = UIFont.systemFont(ofSize: fontConstant, weight: .regular)
            nameInput.textInput.font = UIFont.systemFont(ofSize: fontConstant, weight: .regular)
            nameInput.titleLabel.font = UIFont.systemFont(ofSize: fontConstant, weight: .regular)
            passwordInput.textInput.font = UIFont.systemFont(ofSize: fontConstant, weight: .regular)
            passwordInput.titleLabel.font = UIFont.systemFont(ofSize: fontConstant, weight: .regular)
            
            emailInput.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            emailInput.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -45).isActive = true
            emailInput.widthAnchor.constraint(equalToConstant: 351).isActive = true
            emailInput.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            nameInput.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            nameInput.bottomAnchor.constraint(equalTo: emailInput.topAnchor, constant: -37).isActive = true
            nameInput.widthAnchor.constraint(equalToConstant: 351).isActive = true
            nameInput.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
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
        
        nameInput.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameInput.bottomAnchor.constraint(equalTo: emailInput.topAnchor, constant: -37).isActive = true
        nameInput.widthAnchor.constraint(equalToConstant: 351).isActive = true
        nameInput.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        
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
        registerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -157).isActive = true
        registerButton.widthAnchor.constraint(equalToConstant: 271).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupSignInBar() {
        view.addSubview(signInBar)
        
        if UIDevice.current.modelName == "iPhone 5s" || UIDevice.current.modelName == "iPhone6,1" {
            textLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            var attributedText = NSAttributedString(string: "here",
                                                    attributes:
                [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .bold),
                 NSAttributedStringKey.foregroundColor : UIColor.white]
            )
            signInLink.setAttributedTitle(attributedText, for: .normal)
            
            signInBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            signInBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            signInBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            signInBar.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            signInBar.addSubview(textLabel)
            textLabel.leftAnchor.constraint(equalTo: signInBar.leftAnchor, constant:15).isActive = true
            textLabel.centerYAnchor.constraint(equalTo: signInBar.centerYAnchor).isActive = true
            textLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
            textLabel.heightAnchor.constraint(equalToConstant: 19).isActive = true
            
            signInBar.addSubview(signInLink)
            signInLink.leftAnchor.constraint(equalTo: textLabel.rightAnchor).isActive = true
            signInLink.centerYAnchor.constraint(equalTo: signInBar.centerYAnchor).isActive = true
            signInLink.widthAnchor.constraint(equalToConstant: 36).isActive = true
            signInLink.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            return
        }

        signInBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        signInBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        signInBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        signInBar.heightAnchor.constraint(equalToConstant: 60).isActive = true
    
        signInBar.addSubview(textLabel)
        textLabel.centerXAnchor.constraint(equalTo: signInBar.centerXAnchor, constant: -23).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: signInBar.centerYAnchor).isActive = true
        textLabel.widthAnchor.constraint(equalToConstant: 275).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 19).isActive = true
        
        signInBar.addSubview(signInLink)
        signInLink.leftAnchor.constraint(equalTo: textLabel.rightAnchor, constant: 2).isActive = true
        signInLink.centerYAnchor.constraint(equalTo: signInBar.centerYAnchor).isActive = true
        signInLink.widthAnchor.constraint(equalToConstant: 36).isActive = true
        signInLink.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
    }

}

extension UIView {
    func addConstraints(with format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}












