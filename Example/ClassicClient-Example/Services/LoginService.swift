//
//  LoginService.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-20.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import ClassicClient

struct User: Codable {
    let id: String
}

class LoginService {
    func login() -> Requester<User> {
        return MockRequester(User(id: "123"))
    }
}
