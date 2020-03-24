//
//  LoginViewController.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-20.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

// Photo by Casey Horner on Unsplash

import UIKit

class LoginViewController: UIViewController {
    
    let titleLabel = UILabel()
    let usernameField = UITextField()
    let passwordField = UITextField()
    let loginButton = UIButton()

    let loadingView = LoadingView()
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for view in [titleLabel, usernameField, passwordField, loginButton, backgroundImageView] {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        titleLabel.text = "Classic Client"
        titleLabel.textAlignment = .center
        titleLabel.font = CCStyle.fontWithSize(size: 48, andType: .title)
        titleLabel.textColor = CCStyle.TitleTextColor
        
        loginButton.layer.cornerRadius = 15
        loginButton.setTitle("Log In", for: .normal)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        setLoginButtonState(enabled: false)
        
        for textfield in [usernameField, passwordField] {
            textfield.backgroundColor = UIColor.gray.withAlphaComponent(0.25)
            textfield.layer.borderWidth = 1
            textfield.layer.borderColor = UIColor.black.cgColor
            textfield.tintColor = UIColor.darkGray
            textfield.textColor = CCStyle.TitleTextColor

            textfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)            
        }

        passwordField.isSecureTextEntry = true
        textFieldDidChange(usernameField) // TODO: remove
        
        backgroundImageView.image = #imageLiteral(resourceName: "casey-horner-CN_42yx-2Xo-unsplash")
        self.view.constrainSubviewToBounds(backgroundImageView)
                
        let views = ["title": titleLabel, "username": usernameField, "password": passwordField, "login": loginButton]
        let verticalMetrics = ["paddingTop": 100, "paddingGrouped": 24, "paddingSeperation": 48]
        let horizontalMetrics = ["padding": 28]
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat:
            "V:|-(paddingTop)-[title(75)]-(paddingSeperation)-[username(50)]-(paddingGrouped)-[password(50)]-(paddingSeperation)-[login(50)]",
                                                                 options: .alignAllCenterX, metrics: verticalMetrics, views: views)
        
        let titleHor = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(padding)-[title]-(padding)-|", options: .alignAllCenterY, metrics: horizontalMetrics, views: views)
        let userHor = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(padding)-[username]-(padding)-|", options: .alignAllCenterY, metrics: horizontalMetrics, views: views)
        let passHor = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(padding)-[password]-(padding)-|", options: .alignAllCenterY, metrics: horizontalMetrics, views: views)
        let loginHor = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(padding)-[login]-(padding)-|", options: .alignAllCenterY, metrics: horizontalMetrics, views: views)
        
        for constraint in [verticalConstraints, titleHor, userHor, passHor, loginHor] {
            self.view.addConstraints(constraint)
        }
        
        self.view.sendSubviewToBack(backgroundImageView)
        
        self.view.addSubview(loadingView.view)
        self.addChild(loadingView)
        self.view.constrainSubviewToBounds(loadingView.view)
        self.view.bringSubviewToFront(loadingView.view)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
           
    @objc func login() {
        loadingView.setLoading(true)
        LoginViewModel.sharedInstance.login()
    }
    
    private func setLoginButtonState(enabled: Bool) {
        loginButton.isEnabled = enabled
        loginButton.setTitleColor(enabled ? CCStyle.EnabledButtonTextColor : CCStyle.DisabledButtonTextColor, for: .normal)
        loginButton.backgroundColor = enabled ? CCStyle.EnabledButtonBackgroundColor : CCStyle.DisabledButtonBackgroundColor
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        setLoginButtonState(enabled: (usernameField.text?.count ?? 0 > 0) && (passwordField.text?.count ?? 0 > 0))
    }
    
}
