//
//  CCStyle.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-21.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

public enum FontType: String {
    case title = "Avenir-Heavy"
    case text = "Avenir-Light"
}

struct ColorPalette {
    fileprivate static let darkGrey = UIColor.darkGray
    fileprivate static let darkGreyAlpha = UIColor.darkGray.withAlphaComponent(0.75)
    fileprivate static let white = UIColor.white
    fileprivate static let lightGrey = UIColor.lightGray
    fileprivate static let accentColor = UIColor(rgb: 0x0bbaba)
    fileprivate static let continueColor = UIColor(rgb: 0x04b355)
    fileprivate static let stopColor = UIColor(rgb: 0xcf5408)
}

public struct CCStyle {
    public static let TitleTextColor = ColorPalette.white
    public static let EnabledButtonBackgroundColor = ColorPalette.darkGrey
    public static let DisabledButtonBackgroundColor = ColorPalette.darkGreyAlpha
    public static let EnabledButtonTextColor = ColorPalette.white
    public static let DisabledButtonTextColor = ColorPalette.lightGrey

    public static let majorItemColor = ColorPalette.darkGrey
    public static let minorItemColor = ColorPalette.accentColor
    
    public static let acceptButtonBackgroundColor = ColorPalette.continueColor
    public static let cancelButtonBackgroundColor = ColorPalette.stopColor
    public static let accentButtonBackgroundColor = ColorPalette.accentColor
    
    public static func fontWithSize(size: CGFloat, andType type: FontType = .text) -> UIFont {
        return UIFont.init(name: type.rawValue, size: size) ?? UIFont.init()
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
