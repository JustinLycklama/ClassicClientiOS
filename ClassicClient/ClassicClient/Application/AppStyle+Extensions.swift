//
//  AppStyle+Extensions.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2021-02-03.
//

import UIKit

public protocol TextStylable {
    var fontName: String { get }
    var textColor: UIColor { get }
    var size: CGFloat { get }
}

public enum DefaultTextStyle: String, TextStylable {
    case title = "AvenirNext-DemiBold" //BodoniSvtyTwoITCTT-BookIta"
    case text = "Avenir-Light"
    
    public var fontName: String {
        rawValue
    }
    
    public var textColor: UIColor {
        .black
    }
    
    public var size: CGFloat {
        16
    }
}

public extension UIFont {
    static func fromStyle(style: TextStylable) -> UIFont {
        return UIFont.init(name: style.fontName, size: style.size) ?? UIFont.init()
    }
}

extension UILabel {
    public func style(_ style: TextStylable) {
        self.font = UIFont.fromStyle(style: style)
        self.textColor = style.textColor
    }
}

extension UITextView {
    public func style(_ style: TextStylable) {
        self.font = UIFont.fromStyle(style: style)
        self.textColor = style.textColor
    }
}

extension UITextField {
    public func style(_ style: TextStylable) {
        self.font = UIFont.fromStyle(style: style)
        self.textColor = style.textColor
        
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: bounds.origin.x + App.style.interiorPadding,
                                             y: bounds.origin.y,
                                             width: bounds.size.width - App.style.interiorPadding,
                                             height: bounds.size.height))
    }
}
