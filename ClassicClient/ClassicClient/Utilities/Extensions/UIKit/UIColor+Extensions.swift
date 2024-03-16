//
//  UIColor+Extensions.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-16.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import UIKit

extension Color {
    static func fromHex(_ hex: String) -> UIColor {
        Common.hexStringToUIColor(hex: hex)
    }
}

extension UIColor {
    convenience init(_ hex: String) {
        self.init(cgColor: Common.hexStringToUIColor(hex: hex).cgColor)
    }
}
