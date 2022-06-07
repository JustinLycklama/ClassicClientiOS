//
//  AppStyle+Extensions.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2021-02-03.
//

import UIKit

public typealias AppStyle = (MetricsStyle & ColorStyle & FontStyle)

// MARK: Metrics
public protocol MetricsStyle {
    var topMargin: CGFloat { get }
    var topPadding: CGFloat { get }
    
    var textInset: CGFloat { get }

    var elementMargin: CGFloat { get }
    var elementPadding: CGFloat { get }
    
    var cornerRadius: CGFloat { get }
        
    // Text Area
    var textAreaCornerRadius: CGFloat { get }
}

// MARK: Color
public protocol ColorStyle {
    var primaryColor: UIColor { get }
    var secondaryColor: UIColor { get }
    
    // Views
    var baseBackgroundColor: UIColor { get }
    var shadowColor: UIColor { get }
    
    // Buttons
    var acceptButtonBackgroundColor: UIColor { get }
    var accentButtonBackgroundColor: UIColor { get }
    
    // Text
    var titleTextColor: UIColor { get }
    var titleTextAccentColor: UIColor { get }
    
    // Text Area
    var textAreaBorderColor: UIColor { get }
}

// MARK: Font
public protocol FontStyle {
//    var placeholderFont: UIFont { get }
    
    var placeholderTextAttributes: [NSAttributedString.Key: Any] { get }
}

// MARK: - Extensions

//public protocol TextStylable {
//    var font: UIFont { get }
//    var color: UIColor { get }
////    var size: CGFloat { get }
//}
//
//public struct

public struct NewTextStyle {
    let font: UIFont
    let color: UIColor
    
    public init(font: UIFont, color: UIColor) {
        self.font = font
        self.color = color
    }
    
    public static func + (lhs: NewTextStyle, rhs: UIColor) -> NewTextStyle {
        return NewTextStyle(font: lhs.font, color: rhs)
    }
    
    public var asAttributes: [NSAttributedString.Key : Any] {
        return [NSAttributedString.Key.font : font,
                NSAttributedString.Key.foregroundColor : color]
    }
}

public let DefaultTextStyle = NewTextStyle(font: UIFont.systemFont(ofSize: 15), color: .black)


//public enum DefaultTextStyle: String, TextStylable {
//    case title = "AvenirNext-DemiBold" //BodoniSvtyTwoITCTT-BookIta"
//    case text = "Avenir-Light"
//
//    public var fontName: String {
//        rawValue
//    }
//
//    public var textColor: UIColor {
//        .black
//    }
//
//    public var size: CGFloat {
//        16
//    }
//}

//public extension UIFont {
//    static func fromStyle(style: TextStylable) -> UIFont {
//        return UIFont.init(name: style.fontName, size: style.size) ?? UIFont.init()
//    }
//}

extension UILabel {
    public func style(_ style: NewTextStyle) {
        self.font = style.font
        self.textColor = style.color
    }
}

extension UITextView {
    public func style(_ style: NewTextStyle) {
        self.font = style.font
        self.textColor = style.color
    }
}

extension UITextField {
    public func style(_ style: NewTextStyle) {
        self.backgroundColor = .white
        self.font = style.font
        self.textColor = style.color
        
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: bounds.origin.x + Classic.style.textInset,
                                             y: bounds.origin.y,
                                             width: bounds.size.width - Classic.style.textInset,
                                             height: bounds.size.height))
    }
}
