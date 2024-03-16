//
//  Data+Extensions.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-15.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import Foundation

extension Data {
    func utf8Decoded() -> String? {
        String(data: self, encoding: .utf8)
    }
}
