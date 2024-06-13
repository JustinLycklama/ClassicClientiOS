//
//  CircleView.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-15.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import UIKit

open class CircleView: UIView {

    private let circle = UIView()

    public var color: UIColor {
        didSet {
            circle.backgroundColor = color
        }
    }
    
    public var scaleMode: ScaleMode {
        didSet {
            scaleModeConstraint?.isActive = scaleMode == .aspectFit
        }
    }
    private var scaleModeConstraint: NSLayoutConstraint?
    
    public enum ScaleMode {
        case aspectFit
        case aspectFill
    }
    
    public init(color: UIColor, scaleMode: ScaleMode = .aspectFit) {
        self.scaleMode = scaleMode
        self.color = color
        super.init(frame: .zero)
        
        setupView()
    }
    
    required public init?(coder: NSCoder) {
        self.scaleMode = .aspectFit
        self.color = .white
        super.init(coder: coder)
        
        setupView()
    }
    
    func setupView() {
        backgroundColor = .clear
        circle.backgroundColor = color
        
        addSubview(circle)
        centerSubview(circle)
        
        let width = circle.widthAnchor.constraint(equalTo: widthAnchor)
        width.priority = .defaultLow

        let height = circle.heightAnchor.constraint(equalTo: heightAnchor)
        height.priority = .defaultLow
        
        let scaleConstraint = circle.widthAnchor.constraint(equalTo: circle.heightAnchor)
        circle.addConstraint(scaleConstraint)
        
        scaleConstraint.isActive = scaleMode == .aspectFit
        scaleModeConstraint = scaleConstraint
            
        addConstraint(width)
        addConstraint(height)
    }
    
    open override func layoutSubviews() {
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
