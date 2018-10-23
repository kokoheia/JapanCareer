//
//  ChatLogController.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/01.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit
import Firebase

final class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    private var cellId = "cellId"
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            observeMessage()
        }
    }

    
    private func observeMessage() {
        guard let uid = Auth.auth().currentUser?.uid, let toId = user?.id else {
            return
        }

        let ref = Database.database().reference().child("user-messages").child(uid).child(toId)
        ref.observe(.childAdded, with: { [weak self] (snapshot) in
            let messageId = snapshot.key
            self?.fetchMessage(with: messageId)
        }, withCancel: nil)
        
    }
    
    private func fetchMessage(with messageId: String) {
        let messageRef = Database.database().reference().child("messages").child(messageId)
        messageRef.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                self?.messages.append(message)
                DispatchQueue.main.async {
                    self?.collectionView?.reloadData()
                }
            }
        }, withCancel: nil)
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        
        if let text = message.text {
            cell.textLabel.text = text
            cell.bubbleViewWidthAnchor?.constant = estimateFrame(for: text).width + 32
        }
        
        setupCell(with: cell, message: message)
        
        return cell
    }
    
    private func setupCell(with cell: ChatMessageCell, message: Message) {
        if let profileImageUrl = user?.profileImageUrl {
            cell.profileImageView.loadImageWithCache(with: profileImageUrl)
        }
        
        
        if message.fromId == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = UIColor.mainColor
            cell.textLabel.textColor = .white
            cell.profileImageView.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        } else {
            cell.bubbleView.backgroundColor = UIColor.chatGrayColor
            cell.textLabel.textColor = .black
            cell.profileImageView.isHidden = false
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        if let text = messages[indexPath.row].text {
            height = estimateFrame(for: text).height + 20
        }
        
        return CGSize(width: view.bounds.width, height: height)
    }
    
    private func estimateFrame(for text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .light)], context: nil)
    }
    

    var messages = [Message]()
    
    var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var textInput : UITextField = {
        var textField = CustomTextField()
        textField.placeholder = "Enter text here..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 18
        textField.layer.borderColor = UIColor.myGrayColor.cgColor
        textField.layer.borderWidth = 0.5
        textField.backgroundColor = UIColor.textInputBackgroundGray
        textField.layer.masksToBounds = true
        return textField
    }()

    var sendButton : UIButton = {
        var button = UIButton(type: .system)
        let color = UIColor.mainColor
        let attributedString = NSAttributedString(string: "Send", attributes: [.font : UIFont.systemFont(ofSize: 16, weight: .medium), .foregroundColor: color])
        button.setAttributedTitle(attributedString, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    
    
    @objc private func handleSend() {
        if !textInput.text!.isEmpty {
            let ref = Database.database().reference().child("messages")
            let childRef = ref.childByAutoId()
            let toId = user!.id!
            let fromId = Auth.auth().currentUser!.uid
            let timeStamp = Int(Date().timeIntervalSince1970)
            let value: [String: Any] = ["text": textInput.text!, "toId": toId, "fromId": fromId, "timestamp": timeStamp]
            childRef.updateChildValues(value) { (err, ref) in
                if err != nil {
                    print(err!)
                    return
                }
                let userMessageRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
                let mesageId = childRef.key
                userMessageRef.updateChildValues([mesageId:1])
                
                let recipientUserMessageRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
                recipientUserMessageRef.updateChildValues([mesageId:1])
            }
        }
    }
    
//    var inputContainerViewHeightConstant: CGFloat = 49
    
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        if UIDevice.current.modelName == "iPhone X" || UIDevice.current.modelName == "iPhone10,3" {
            containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 69)
        } else {
            containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 49)
        }
        
        var sendButton = UIButton(type: .system)
        let color = UIColor.mainColor
        let attributedString = NSAttributedString(string: "Send", attributes: [.font : UIFont.systemFont(ofSize: 16, weight: .medium), .foregroundColor: color])
        sendButton.setAttributedTitle(attributedString, for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        var separatorLine = UIView()
        separatorLine.backgroundColor = UIColor.myLightGrayColor
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(textInput)
        containerView.addSubview(sendButton)
        containerView.addSubview(separatorLine)

        
        textInput.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 14).isActive = true
        textInput.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 6).isActive = true
        textInput.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -67).isActive = true
        textInput.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        if UIDevice.current.modelName == "iPhone X" || UIDevice.current.modelName == "iPhone10,3" {
            sendButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15).isActive = true
        } else {
            sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        }
        sendButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 19).isActive = true
        
        separatorLine.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLine.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    var separatorLine: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.myLightGrayColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
//        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 58, right: 0)
        collectionView?.backgroundColor = .white
        textInput.delegate = self
        collectionView!.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
//        collectionView?.keyboardDismissMode = .interactive
        tabBarController?.tabBar.isHidden = true
        
        setupViews()
//        setupInputComponents()
//        setupKeyboardObservers()
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
//    private func setupInputComponents() {
//        let containerView = UIView()
//        containerView.backgroundColor = .white
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(containerView)
//
//        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        containerViewBottomAnchor?.isActive = true
//        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        var sendButton = UIButton(type: .system)
//        let color = UIColor.mainColor
//        let attributedString = NSAttributedString(string: "Send", attributes: [.font : UIFont.systemFont(ofSize: 16, weight: .medium), .foregroundColor: color])
//        sendButton.setAttributedTitle(attributedString, for: .normal)
//        sendButton.translatesAutoresizingMaskIntoConstraints = false
//        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
//
//        var separatorLine = UIView()
//        separatorLine.backgroundColor = UIColor.myLightGrayColor
//        separatorLine.translatesAutoresizingMaskIntoConstraints = false
//
//        containerView.addSubview(textInput)
//        containerView.addSubview(sendButton)
//        containerView.addSubview(separatorLine)
//
//        textInput.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 14).isActive = true
//        textInput.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 6).isActive = true
//        textInput.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -67).isActive = true
//        textInput.heightAnchor.constraint(equalToConstant: 36).isActive = true
//
//        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
//        if UIDevice.current.modelName == "iPhone X" || UIDevice.current.modelName == "iPhone10,3" {
//            sendButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15).isActive = true
//        } else {
//            sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        }
//        sendButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        sendButton.heightAnchor.constraint(equalToConstant: 19).isActive = true
//
//        separatorLine.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
//        separatorLine.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
//        separatorLine.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
//        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
//    }
    
//    private func setupKeyboardObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
//    }
    
    
//    @objc private func handleKeyboardWillShow(notification: NSNotification) {
//        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
//        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
//        containerViewBottomAnchor?.constant = -keyboardFrame!.height
//        UIView.animate(withDuration: keyboardDuration!) { [weak self] in
//            self?.view.layoutIfNeeded()
//        }
//    }
//
//    @objc private func handleKeyboardWillHide(notification: NSNotification) {
//        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
//        containerViewBottomAnchor?.constant = 0
//        UIView.animate(withDuration: keyboardDuration!) { [weak self] in
//            self?.view.layoutIfNeeded()
//        }
//    }

    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        textField.text = ""
        return true
    }

    private func setupViews() {
        view.addSubview(containerView)
        view.addSubview(textInput)
        view.addSubview(sendButton)
        view.addSubview(separatorLine)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 49).isActive = true
        
        textInput.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 14).isActive = true
        textInput.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        textInput.widthAnchor.constraint(equalToConstant: 294).isActive = true
        textInput.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 19).isActive = true
        
        separatorLine.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLine.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}


class CustomTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
    }
}


