//
//  ItemTableViewCell.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-23.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet var itemName: UILabel!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var twoItemDisplay: TwoItemFocusDisplay!
    
    var item: Item?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        itemName.font = CCStyle.fontWithSize(size: 18)
        
        editButton.setTitle("Edit", for: .normal)
        editButton.backgroundColor = CCStyle.accentButtonBackgroundColor
        editButton.titleLabel?.font = CCStyle.fontWithSize(size: 18)
        editButton.layer.cornerRadius = 8
        editButton.setTitleColor(CCStyle.EnabledButtonTextColor, for: .normal)
    }

    func setItem(item: Item) {
        itemName.text = item.name
        
        let countString = "x\(item.count)"
        let weightString = "\(item.kgPerUnit * CGFloat(item.count)) Kg"
        
        twoItemDisplay.setItems(major: weightString, minor: countString)
    }
}
