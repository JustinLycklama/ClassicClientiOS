//
//  CircleView.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-15.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import UIKit

class CircleView: UIView {

    private let circle = UIView()
    
    enum ScaleMode {
        case aspectFit
        case aspectFill
    }
    
    init(color: UIColor, scaleMode: ScaleMode = .aspectFit) {
        super.init(frame: .zero)
        
        backgroundColor = .clear
        circle.backgroundColor = color
        
        addSubview(circle)
        centerSubview(circle)
        
        let width = circle.widthAnchor.constraint(equalTo: widthAnchor)
        width.priority = .defaultLow

        let height = circle.heightAnchor.constraint(equalTo: heightAnchor)
        height.priority = .defaultLow
        
        if scaleMode == .aspectFit {
            circle.addConstraint(circle.widthAnchor.constraint(equalTo: circle.heightAnchor))
        }
        
        addConstraint(width)
        addConstraint(height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        circle.cornerRadius = min(circle.frame.size.width/2, circle.frame.size.height/2)
    }
    
    func setCircleHidden(_ isHidden: Bool) {
        circle.isHidden = isHidden
    }
    
    func setColor(_ color: UIColor) {
        circle.backgroundColor = color
    }
}
