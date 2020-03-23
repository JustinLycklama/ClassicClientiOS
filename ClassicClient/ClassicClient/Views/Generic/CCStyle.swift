//
//  CCStyle.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-21.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

struct ColorPalette {
    fileprivate static let darkGrey = UIColor.darkGray
    fileprivate static let darkGreyAlpha = UIColor.darkGray.withAlphaComponent(0.75)
    fileprivate static let white = UIColor.white
    fileprivate static let lightGrey = UIColor.lightGray
}

struct CCStyle {
    public static let EnabledButtonBackgroundColor = ColorPalette.darkGrey
    public static let DisabledButtonBackgroundColor = ColorPalette.darkGreyAlpha
    public static let EnabledButtonTextColor = ColorPalette.white
    public static let DisabledButtonTextColor = ColorPalette.lightGrey    
}
