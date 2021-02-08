//
//  ShortStringCell.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-15.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

public struct ShortTextField: Field {
    public let identifier = "ShortTextCell"
    public let cellClass: UITableViewCell.Type = ShortStringCell.self
    
    private let title: String
    private let initialValue: String?
    private let onUpdate: ((String) -> Void)
    
    public init(title: String, initialValue: String?, onUpdate: @escaping ((String) -> Void)) {
        self.title = title
        self.initialValue = initialValue
        self.onUpdate = onUpdate
    }
    
    public func configureCell(_ cell: UITableViewCell) {
        if let shortTextCell = cell as? ShortStringCell {
            shortTextCell.title = title
            shortTextCell.initialValue = initialValue
            shortTextCell.onUpdate = onUpdate
        }
    }
}

class ShortStringCell: UITableViewCell {
    
    let valueTextField = UITextField()
    
    var title: String = "" {
        didSet {
            valueTextField.attributedPlaceholder =
                NSAttributedString(string: title, attributes: App.style.placeholderTextAttributes)
        }
    }
    
    var initialValue: String? = nil {
        didSet {
            valueTextField.text = initialValue
        }
    }
    
    var onUpdate: ((String) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        valueTextField.style(DefaultTextStyle.text)
        
        valueTextField.layer.cornerRadius = App.style.textAreaCornerRadius
        valueTextField.layer.borderWidth = 1
        valueTextField.layer.borderColor = App.style.textAreaBorderColor.cgColor
        
        selectionStyle = .none
        valueTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        self.contentView.addSubview(valueTextField)
        self.contentView.constrainSubviewToBounds(valueTextField, withInset: UIEdgeInsets(App.style.interiorMargin))
    }
    
    public func styleWith(_ style: TextStylable) {
        valueTextField.style(style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc
    func textFieldDidChange(textField: UITextField) {
        onUpdate?(textField.text ?? "")
    }
}