//
//  ListCell.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-01-22.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit

public struct ListField: Field {
    public let identifier = "ListCell"
    public let cellClass: UITableViewCell.Type = ListCell.self
    
    private let title: String
    private let values: [String]
    
    public init(title: String, values: [String]) {
        self.title = title
        self.values = values
    }
    
    public func configureCell(_ cell: UITableViewCell) {
        if let listCell = cell as? ListCell {
            listCell.title = title
            listCell.items = values
        }
    }
}

class ListCell: UITableViewCell {

    let titleLabel = UILabel()
    let itemsLabel = UILabel()
    
    var title: String = "" {
        didSet {
            titleLabel.text = title + ":"
            titleLabel.sizeToFit()
        }
    }
    
    var items: [String] = [] {
        didSet {
            var itemsString = items.reduce("") { (soFar, item) -> String in
                return soFar + "\u{2022} \(item)\n"
            }
            
            itemsString.removeLast()
            itemsLabel.text = itemsString
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        itemsLabel.translatesAutoresizingMaskIntoConstraints = false
        itemsLabel.numberOfLines = 0
        
        selectionStyle = .none
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = Classic.style.elementPadding
        
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        itemsLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        let titleContainer = UIView()
        titleContainer.addSubview(titleLabel)
        titleContainer.constrainSubviewToBounds(titleLabel, onEdges: [.top, .left, .right])
        
        stack.addArrangedSubview(titleContainer)
        stack.addArrangedSubview(itemsLabel)
        
        let stackContainer = UIView()
        
        stackContainer.layer.cornerRadius = Classic.style.textAreaCornerRadius
        stackContainer.layer.borderWidth = 1
        stackContainer.layer.borderColor = Classic.style.textAreaBorderColor.cgColor
        
        stackContainer.addSubview(stack)
        stackContainer.constrainSubviewToBounds(stack, withInset: UIEdgeInsets(Classic.style.textInset))
        
        self.addSubview(stackContainer)
        self.constrainSubviewToBounds(stackContainer, withInset: UIEdgeInsets(Classic.style.textInset))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
