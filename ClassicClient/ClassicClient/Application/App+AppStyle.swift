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

extension MetricsStyle {
    var topMargin: CGFloat { 18 }
    var topPadding: CGFloat { 16 }
    
    var interiorMargin: CGFloat { 12 }
    var interiorPadding: CGFloat { 8 }
    
    var cornerRadius: CGFloat { 10 }
    
    // Forms
    var formPadding: CGFloat { interiorMargin }
    var formMargin: CGFloat { interiorPadding }

    // Text Area
    var textAreaCornerRadius: CGFloat { cornerRadius }
}

// MARK: Color
public protocol ColorStyle {
    var primaryColor: UIColor { get }
    var secondaryColor: UIColor { get }
    
    // Buttons
    var acceptButtonBackgroundColor: UIColor { get }
    var accentButtonBackgroundColor: UIColor { get }
    
    // Text Area
    var textAreaBorderColor: UIColor { get }
}

extension ColorStyle {
    var primaryColor: UIColor { ColorPalette.darkGrey }
    var secondaryColor: UIColor { ColorPalette.accentColor }
    
    // Buttons
    var acceptButtonBackgroundColor: UIColor { ColorPalette.continueColor }
    var accentButtonBackgroundColor: UIColor { ColorPalette.accentColor }
    
    // Text Area
    var textAreaBorderColor: UIColor { ColorPalette.lightGrey }

}

// MARK: Font
public protocol FontStyle {
//    var placeholderFont: UIFont { get }
    
    var placeholderTextAttributes: [NSAttributedString.Key: Any] { get }
}

extension FontStyle {
//    var placeholderFont: UIFont { FontBook.placeholderFont }
    
    var placeholderTextAttributes: [NSAttributedString.Key: Any] { attributesForStyle(DefaultTextStyle.text) }
    
    func attributesForStyle(_ style: TextStylable) -> [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.font : UIFont.fromStyle(style: style) ?? UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor : style.textColor]
    }
}


// MARK: - Classic Client Style

private struct FontBook {

    
    fileprivate static let placeholderFont = UIFont.fromStyle(style: DefaultTextStyle.text)
}

private struct ColorPalette {
    fileprivate static let darkGrey = UIColor.darkGray
    fileprivate static let darkGreyAlpha = UIColor.darkGray.withAlphaComponent(0.75)
    fileprivate static let white = UIColor.white
    fileprivate static let lightGrey = UIColor.lightGray
    fileprivate static let accentColor = UIColor(rgb: 0x0bbaba)
    fileprivate static let continueColor = UIColor(rgb: 0x04b355)
    fileprivate static let stopColor = UIColor(rgb: 0xcf5408)
    
    fileprivate static let darkTeal = UIColor(rgb: 0x006d77)
    fileprivate static let lightTeal = UIColor(rgb: 0x83c5be)
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
        self.leftView = UIView(frame: CGRect(x: bounds.origin.x + App.style.interiorPadding,
                                             y: bounds.origin.y,
                                             width: bounds.size.width - App.style.interiorPadding,
                                             height: bounds.size.height))
    }
}
