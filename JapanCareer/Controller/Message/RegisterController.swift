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
    
    var dismissButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("dismiss", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleDismiss() {
        dismiss(animated: true, completion: nil)
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
        inputView.titleLabel.text = "Name"
        inputView.imageIcon.image = UIImage(named: "account")
        inputView.translatesAutoresizingMaskIntoConstraints = false
        return inputView
    }()
    
    var emailInput: LoginInputCell = {
        var inputView = LoginInputCell()
        inputView.titleLabel.text = "Email"
        inputView.imageIcon.image = UIImage(named: "email")
        inputView.translatesAutoresizingMaskIntoConstraints = false
        return inputView
    }()
    
    var passwordInput: LoginInputCell = {
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
        loginController.messageControler = messageController
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
        setupImageView()
        setupSegmentedControl()
    
        view.addSubview(dismissButton)
        dismissButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        dismissButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupSegmentedControl() {
        view.addSubview(studentCompanySegmentedControl)
        studentCompanySegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        studentCompanySegmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 210).isActive = true
        studentCompanySegmentedControl.widthAnchor.constraint(equalToConstant: 244).isActive = true
        studentCompanySegmentedControl.heightAnchor.constraint(equalToConstant: 29).isActive = true
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 71).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func setupTextView() {
        view.addSubview(titleText)
        titleText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleText.topAnchor.constraint(equalTo: view.topAnchor, constant: 132).isActive = true
        titleText.widthAnchor.constraint(equalToConstant: 231).isActive = true
        titleText.heightAnchor.constraint(equalToConstant: 29).isActive = true
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
        
        nameInput.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameInput.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -373).isActive = true
        nameInput.widthAnchor.constraint(equalToConstant: 351).isActive = true
        nameInput.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        emailInput.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        emailInput.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -302).isActive = true
        emailInput.widthAnchor.constraint(equalToConstant: 351).isActive = true
        emailInput.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        passwordInput.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        passwordInput.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -228).isActive = true
        passwordInput.widthAnchor.constraint(equalToConstant: 351).isActive = true
        passwordInput.heightAnchor.constraint(equalToConstant: 35).isActive = true

    }
    
    private func setupButton() {
        view.addSubview(registerButton)
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -117).isActive = true
        registerButton.widthAnchor.constraint(equalToConstant: 271).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupSignInBar() {
        view.addSubview(signInBar)
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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












