//
//  LoginViewController.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-20.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient

class LoginViewController: UIViewController {
    
    let titleLabel = UILabel()
    let usernameField = UITextField()
    let passwordField = UITextField()
    let loginButton = UIButton()

    let loadingView = SpinnerLoadingView()
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "desert")
        imageView.contentMode = .scaleAspectFit
        
        view.borderColor = .red
        view.borderWidth = 2
        
        view.constrainView(imageView)
//
//        for view in [titleLabel, usernameField, passwordField, loginButton, backgroundImageView] {
//            view.translatesAutoresizingMaskIntoConstraints = false
//            self.view.addSubview(view)
//        }
//        
//        titleLabel.text = "Classic Client"
//        titleLabel.textAlignment = .center
//        titleLabel.font = CCStyle.fontWithSize(size: 48, andType: .title)
//        titleLabel.textColor = CCStyle.TitleTextColor
//                
//        loginButton.layer.cornerRadius = 15
//        loginButton.setTitle("Log In", for: .normal)
//        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
//        setLoginButtonState(enabled: false)
//        
//        for textfield in [usernameField, passwordField] {
//            textfield.backgroundColor = UIColor.gray.withAlphaComponent(0.25)
//            textfield.layer.borderWidth = 1
//            textfield.layer.borderColor = UIColor.black.cgColor
//            textfield.tintColor = UIColor.darkGray
//            textfield.textColor = CCStyle.TitleTextColor
//
//            textfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)            
//        }
//
//        passwordField.isSecureTextEntry = true
//        textFieldDidChange(usernameField) // TODO: remove
//        
//        backgroundImageView.image = #imageLiteral(resourceName: "casey-horner-CN_42yx-2Xo-unsplash")
//        self.view.constrainSubviewToBounds(backgroundImageView)
//                
//        self.view.sendSubviewToBack(backgroundImageView)
//        
//        self.view.addSubview(loadingView.view)
//        self.addChild(loadingView)
//        self.view.constrainSubviewToBounds(loadingView.view)
//        self.view.bringSubviewToFront(loadingView.view)
//        
//        let views = ["title" : titleLabel, "username" : usernameField, "password" : passwordField, "login" : loginButton]
//        
//        let center = NSLayoutConstraint.init(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
//        
//        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(25)-[title]-(25)-[username(44)]-(25)-[password(44)]-(25)-[login(44)]", options: .alignAllCenterX, metrics: nil, views: views)
//        
//        let userHor = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(25)-[username]-(25)-|", options: .alignAllCenterX, metrics: nil, views: views)
//        let passHor = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(25)-[password]-(25)-|", options: .alignAllCenterX, metrics: nil, views: views)
//        let loginHor = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(25)-[login]-(25)-|", options: .alignAllCenterX, metrics: nil, views: views)
//        
//        self.view.addConstraint(center)
//        self.view.addConstraints(verticalConstraint)
//        
//        self.view.addConstraints(userHor)
//        self.view.addConstraints(passHor)
//        self.view.addConstraints(loginHor)
    }

//    override func viewWillAppear(_ animated: Bool) {
////        self.navigationController?.setNavigationBarHidden(true, animated: false)
//    }
           
    @objc func login() {
//        loadingView.setLoading(true)
        LoginViewModel.sharedInstance.login()
    }
    
    private func setLoginButtonState(enabled: Bool) {
//        loginButton.isEnabled = enabled
//        loginButton.setTitleColor(enabled ? CCStyle.EnabledButtonTextColor : CCStyle.DisabledButtonTextColor, for: .normal)
//        loginButton.backgroundColor = enabled ? CCStyle.EnabledButtonBackgroundColor : CCStyle.DisabledButtonBackgroundColor
    }
    
//    @objc func textFieldDidChange(_ textfield: UITextField) {
//        setLoginButtonState(enabled: (usernameField.text?.count ?? 0 > 0) && (passwordField.text?.count ?? 0 > 0))
//    }
    
}
