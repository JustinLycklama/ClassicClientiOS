//
//  UILabel+Extensions.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-05-28.
//

import Foundation

extension UILabel {
    
    public convenience init(text: String?, font: UIFont?, color: UIColor, alignment: NSTextAlignment) {
        self.init()
        
        self.text = text
        self.font = font
        self.textColor = color
        self.textAlignment = alignment
    }
}
