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
    
    public static func setAppStyle(_ style: AppStyle) {
        self.style = style
    }
}

struct DefaultStyle: AppStyle {}

public typealias AppStyle = (MetricsStyle & ColorStyle & FontStyle)

// MARK: - Metrics
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

// MARK: - Color
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

// MARK: - Font
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
