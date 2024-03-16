//
//  AppStyle.swift
//  ClassicClient-Example
//
//  Created by Justin Lycklama on 2024-03-15.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

struct Style {
    static let headerTextColor: UIColor = .white
    static let fadedTextColor: UIColor = ColorBook.grey
    
    static let viewControllerBackground: UIColor = .black
}

// MARK: - ColorBook

struct ColorBook {
    static let grey: UIColor = #colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1) // 6E6E6E
    
}

// MARK: FontBook

struct FontBook {
    enum FontType: String {
        case light = "PingFangHK-Light"
        case thin = "PingFangHK-Thin"
        case regular = "PingFangHK-Regular"
        case medium = "PingFangHK-Medium"
        case semiBold = "PingFangHK-Semibold"
    }
    
    static func font(_ type: FontType, withSize size: CGFloat) -> UIFont {
        return UIFont(name: type.rawValue, size: size) ?? .systemFont(ofSize: size)
    }
}
