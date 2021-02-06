//
//  UIEdgeInsets+Extensions.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2021-02-03.
//

import UIKit

public extension UIEdgeInsets {
    public init(_ value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }
}
