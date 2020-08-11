//
//  WeightCountDisplay.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-23.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

public class TwoItemFocusDisplay: UIView {

    let majorLabel = UILabel()
    let minorLabel = UILabel()
    
    let majorView = UIView()
    let minorView = UIView()
    
    private let cornerRadius: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialize()
    }
    
    func initialize()
    {
        for view in [majorLabel, minorLabel, majorView, minorView] {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        for label in [majorLabel, minorLabel] {
            label.textColor = CCStyle.EnabledButtonTextColor
            label.textAlignment = .center
            label.font = CCStyle.fontWithSize(size: 16)
        }
        
        majorView.addSubview(majorLabel)
        majorView.constrainSubviewToBounds(majorLabel)
        
        minorView.addSubview(minorLabel)
        minorView.constrainSubviewToBounds(minorLabel)
        
        let views = ["weight" : majorView, "count" : minorView]
        
        let horConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[weight]-(0)-[count]-(0)-|", options: .alignAllCenterY, metrics: nil, views: views)
        let vertWeight = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[weight]-(0)-|", options: .alignAllCenterX, metrics: nil, views: views)
        let vertCount = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[count]-(0)-|", options: .alignAllCenterX, metrics: nil, views: views)

        let equality = NSLayoutConstraint.init(item: minorView, attribute: .width, relatedBy: .equal, toItem: majorView, attribute: .width, multiplier: 0.75, constant: 0)
        
        for constraints in [horConstraints, vertWeight, vertCount, [equality]] {
            addConstraints(constraints)
        }
        
        for view in [self, majorView] {
            view.layer.cornerRadius = cornerRadius
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.clear.cgColor
        }

        majorView.backgroundColor = CCStyle.majorItemColor
        majorLabel.text = "Weight"
        
        minorView.backgroundColor = .clear
        minorLabel.text = "Count"
        
        self.backgroundColor = CCStyle.minorItemColor
    }
    
    public func setItems(major: String, minor: String) {
        majorLabel.text = major
        minorLabel.text = minor
    }
}
