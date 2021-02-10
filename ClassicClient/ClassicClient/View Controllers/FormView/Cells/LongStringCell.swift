//
//  LongStringCell.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-19.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

public struct LongTextField: Field {
    public let identifier = "LongTextCell"
    public let cellClass: UITableViewCell.Type = LongStringCell.self
    
    private let title: String
    private let initialValue: String?
    private let onUpdate: ((String) -> Void)
    
    public init(title: String, initialValue: String?, onUpdate: @escaping ((String) -> Void)) {
        self.title = title
        self.initialValue = initialValue
        self.onUpdate = onUpdate
    }
    
    public func configureCell(_ cell: UITableViewCell) {
        if let longTextCell = cell as? LongStringCell {
            longTextCell.title = title
            longTextCell.initialValue = initialValue
            longTextCell.onUpdate = onUpdate
        }
    }
}

class LongStringCell: UITableViewCell {

    let textView = UITextView()
    let borderView = UIView()
    
    let placeholderLabel = UILabel()
    
    var title: String = "" {
        didSet {
            placeholderLabel.text = title
        }
    }
    
    var initialValue: String? = nil {
        didSet {
            textView.text = initialValue
            placeholderLabel.isHidden = !textView.text.isEmpty
        }
    }
    
    var onUpdate: ((String) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none

        textView.style(DefaultTextStyle.text)
        
        textView.delegate = self
        
        placeholderLabel.text = "Enter some text..."
        placeholderLabel.style(DefaultTextStyle.text)
        placeholderLabel.sizeToFit()
        
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        borderView.layer.cornerRadius =  Classic.style.textAreaCornerRadius
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor =  Classic.style.textAreaBorderColor.cgColor
        
        borderView.addSubview(textView)
        borderView.constrainSubviewToBounds(textView, withInset: UIEdgeInsets(1))
        
        self.contentView.addSubview(borderView)
        self.contentView.constrainSubviewToBounds(borderView, withInset: UIEdgeInsets(Classic.style.interiorMargin))
        
        borderView.addConstraint(.init(item: borderView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 128))
    }
    
    public func styleWith(textStyle: TextStylable, placeholderStyle: TextStylable) {
        textView.style(textStyle)
        placeholderLabel.style(placeholderStyle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension LongStringCell: UITextViewDelegate {
    
    
    func textViewDidChange(_ textView: UITextView) {
        onUpdate?(textView.text ?? "")
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//
//        // Combine the textView text and the replacement text to
//        // create the updated text string
//        let currentText:String = textView.text
//        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
//
//        // If updated text view will be empty, add the placeholder
//        // and set the cursor to the beginning of the text view
//        if updatedText.isEmpty {
//
//            textView.text = "Placeholder"
//            textView.textColor = UIColor.lightGray
//
//            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
//        }
//
//        // Else if the text view's placeholder is showing and the
//        // length of the replacement string is greater than 0, set
//        // the text color to black then set its text to the
//        // replacement string
//         else if textView.textColor == UIColor.lightGray && !text.isEmpty {
//            textView.textColor = UIColor.black
//            textView.text = text
//        }
//
//        // For every other case, the text should change with the usual
//        // behavior...
//        else {
//            return true
//        }
//
//        // ...otherwise return false since the updates have already
//        // been made
//        return false
//    }
//
//    func textViewDidChangeSelection(_ textView: UITextView) {
//        if self.window != nil {
//            if textView.textColor == UIColor.lightGray {
//                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
//            }
//        }
//    }
}
