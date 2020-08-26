//
//  AchievementCollectionViewCell.swift
//  ClassicClient-Example
//
//  Created by Justin Lycklama on 2020-08-25.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class AchievementCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var title: UILabel!
    @IBOutlet private var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    public func setAchievement(achievement: Achievement?) {
        guard let achievement = achievement else {
            title.text = "None"
            time.text = ""
            return
        }
        
        title.text = achievement.name
        time.text = achievement.time ?? "Not Yet"
        
        self.contentView.alpha = (achievement.time != nil) ? 1 : 0.5
    }
}
