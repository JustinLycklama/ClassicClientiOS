//
//  UIEdge+Extensions.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-15.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

extension UIEdgeInsets {
    public init(_ value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }
    
    public static func horizontalInsets(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: value, bottom: 0, right: value)
    }
    
    public static func verticalInsets(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: value, left: 0, bottom: value, right: 0)
    }
}
