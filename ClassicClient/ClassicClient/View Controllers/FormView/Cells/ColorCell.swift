//
//  ColorCell.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-16.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

public struct ColorField: Field {
    public let identifier = "ColorCell"
    public let cellClass: UITableViewCell.Type = ColorCell.self
        
    private let onUpdate: ((UIColor) -> Void)
    
    public init(title: String, initialValue: UIColor?, onUpdate: @escaping ((UIColor) -> Void)) {
        self.onUpdate = onUpdate
    }
    
    public func configureCell(_ cell: UITableViewCell) {
        if let colorCell = cell as? ColorCell {
            colorCell.onUpdate = onUpdate
        }
    }
}

class ColorCell: UITableViewCell {

    let titleLabel = UILabel()
    let colorPicker = HSBColorPicker()
        
    var onUpdate: ((UIColor) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        
        colorPicker.delegate = self
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        self.addSubview(titleLabel)
        self.constrainSubviewToBounds(titleLabel, onEdges: [.top, .left, .right], withInset: UIEdgeInsets(Classic.style.textInset))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ColorCell: HSBColorPickerDelegate {
    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizer.State) {
        onUpdate?(color)
    }
}
