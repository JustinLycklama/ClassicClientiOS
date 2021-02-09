//
//  CCStyle.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-21.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit



public struct App {
    public private(set) static var style: AppStyle = DefaultStyle()
    public private(set) static var resources = AppResources()
    
    public static func setAppStyle(_ style: AppStyle) {
        self.style = style
    }
}



struct DefaultStyle: AppStyle {}


// MARK: - AppStyle

