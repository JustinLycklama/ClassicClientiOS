//
//  AchievementHeaderCell.swift
//  ClassicClient-Example
//
//  Created by Justin Lycklama on 2020-08-26.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class AchievementHeaderCell: UICollectionViewCell {

    @IBOutlet private var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
}
