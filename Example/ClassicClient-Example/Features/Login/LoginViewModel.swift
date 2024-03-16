//
//  LoginViewModel.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-20.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient

class LoginViewModel {
    public static let sharedInstance = LoginViewModel()
    
    private let service: LoginService
    
    init() {
        service = LoginService()
    }
    
    public func login() {
        service
            .login()
            .doRequest { result in
                switch result {
                case .success(let user):
                    break
                case .failure(let error):
                    break
                }
            }
    }
    
    public func logout() {

    }
}
