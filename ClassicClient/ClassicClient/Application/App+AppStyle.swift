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
    
    var interiorMargin: CGFloat { get }
    var interiorPadding: CGFloat { get }
    
    var cornerRadius: CGFloat { get }
    
    // Forms
    var formPadding: CGFloat { get }
    var formMargin: CGFloat { get }
    
    // Text Area
    var textAreaCornerRadius: CGFloat { get }
}

// MARK: Color
public protocol ColorStyle {
    var primaryColor: UIColor { get }
    var secondaryColor: UIColor { get }
    
    // Views
    var baseBackgroundColor: UIColor { get }
    
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
        self.leftView = UIView(frame: CGRect(x: bounds.origin.x + Classic.style.interiorPadding,
                                             y: bounds.origin.y,
                                             width: bounds.size.width - Classic.style.interiorPadding,
                                             height: bounds.size.height))
    }
}
