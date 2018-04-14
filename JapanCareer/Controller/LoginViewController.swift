//
//  LoginViewController.swift
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
        filterView.backgroundColor = UIColor(r: 150, g: 150, b: 150, a: 0.5)
        filterView.translatesAutoresizingMaskIntoConstraints = false
        return filterView
    }()
    
    private var backButton: ButtonWithImage = {
        var button = ButtonWithImage()
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
        button.backgroundColor = UIColor(r: 240, g: 99, b: 115)
        button.setTitle("Register", for: .normal)
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
        guard let email = emailInput.textInput.text, let password = passwordInput.textInput.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, err) in
            if err != nil {
                print(err!)
                return
            }
            self?.present(UINavigationController(rootViewController: MessageViewController())
, animated: true, completion: nil)
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
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(handleBack))
        backButton.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
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
        titleText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleText.topAnchor.constraint(equalTo: view.topAnchor, constant: 132).isActive = true
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
        
        emailInput.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        emailInput.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -344).isActive = true
        emailInput.widthAnchor.constraint(equalToConstant: 351).isActive = true
        emailInput.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        passwordInput.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        passwordInput.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -270).isActive = true
        passwordInput.widthAnchor.constraint(equalToConstant: 351).isActive = true
        passwordInput.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
    }
    
    private func setupButton() {
        view.addSubview(registerButton)
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -159).isActive = true
        registerButton.widthAnchor.constraint(equalToConstant: 271).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

}

extension UIButton {
    func selectedButton(title:String, iconName: String, widthConstraints: NSLayoutConstraint){
        self.backgroundColor = UIColor(red: 0, green: 118/255, blue: 254/255, alpha: 1)
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .highlighted)
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor.white, for: .highlighted)
        self.setImage(UIImage(named: iconName), for: .normal)
        self.setImage(UIImage(named: iconName), for: .highlighted)
        let imageWidth = self.imageView!.frame.width
        let textWidth = (title as NSString).size(withAttributes:[NSAttributedStringKey.font:self.titleLabel!.font!]).width
        let width = textWidth + imageWidth + 24
        //24 - the sum of your insets from left and right
        widthConstraints.constant = width
        self.layoutIfNeeded()
    }
}
