//
//  LoginViewModel.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-20.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient

protocol LoginUpdateDelegate: class {
    func LoginStateUpdated(loggedIn: Bool)
}

class LoginViewModel {
    public static let sharedInstance = LoginViewModel()
    
    private var isLoggedIn: Bool
    private var delegates = [LoginUpdateDelegate]()
    
    private let loginService: LoginService
    
    init() {
        isLoggedIn = false
        loginService = LoginService()
    }
    
    public func login() {
        loginService.request { [weak self] (result: Result<String>) in
            // Take some shortcuts here, assume the login/logout request always succeeds
            self?.isLoggedIn = true
            self?.notifyDelegates()
        }
    }
    
    public func logout() {
        loginService.request { [weak self] (result: Result<String>) in
            // Take some shortcuts here, assume the login/logout request always succeeds
            self?.isLoggedIn = false
            self?.notifyDelegates()
        }
    }
    
    private func notifyDelegates() {
        delegates.forEach { (delegate: LoginUpdateDelegate) in
            delegate.LoginStateUpdated(loggedIn: isLoggedIn)
        }
    }
    
    public func subscribeToUpdates(delegate: LoginUpdateDelegate) {
        delegates.append(delegate)
    }
    
    public func unsubscribeFromUpdates(delegate: LoginUpdateDelegate) {
        if let index = delegates.firstIndex(where: { $0 === delegate }) {
            delegates.remove(at: index)
        }
    }
}
