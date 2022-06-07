//
//  DefaultStyle+AppStyle.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2021-02-09.
//

import Foundation

struct DefaultStyle {}

extension DefaultStyle: MetricsStyle {
    var topMargin: CGFloat { 18 }
    var topPadding: CGFloat { 16 }

    var textInset: CGFloat { 12 }
    
    var elementMargin: CGFloat { 8 }
    var elementPadding: CGFloat { 8 }

    var cornerRadius: CGFloat { 16 }

    // Text Area
    var textAreaCornerRadius: CGFloat { cornerRadius }
}


extension DefaultStyle: ColorStyle {
    var primaryColor: UIColor { ColorPalette.darkGrey }
    var secondaryColor: UIColor { ColorPalette.accentColor }

    // Views
    var baseBackgroundColor: UIColor { ColorPalette.white }
    var shadowColor: UIColor { ColorPalette.darkGrey }
    
    // Buttons
    var acceptButtonBackgroundColor: UIColor { ColorPalette.continueColor }
    var accentButtonBackgroundColor: UIColor { ColorPalette.accentColor }

    // Text
    var titleTextColor: UIColor { ColorPalette.white }
    var titleTextAccentColor: UIColor { ColorPalette.accentColor }
    
    // Text Area
    var textAreaBorderColor: UIColor { ColorPalette.lightGrey }

}

extension DefaultStyle: FontStyle {
//    var placeholderFont: UIFont { FontBook.placeholderFont }

    var placeholderTextAttributes: [NSAttributedString.Key: Any] { attributesForStyle(DefaultTextStyle) }

    func attributesForStyle(_ style: NewTextStyle) -> [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.font : style.font,
                NSAttributedString.Key.foregroundColor : style.color]
    }
}

//private struct FontBook {
//    fileprivate static let placeholderFont = UIFont.fromStyle(style: DefaultTextStyle.text)
//}

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
