//
//  Spacer.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-15.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import UIKit

open class Spacer: UIView {
    public enum Dimension {
        case vertical(_ space: CGFloat)
        case horizontal(_ space: CGFloat)
    }
    
    public init(_ dimension: Dimension) {
        super.init(frame: .zero)
        
        switch dimension {
        case .vertical(let space):
            addConstraint(heightAnchor.constraint(equalToConstant: space))
        case .horizontal(let space):
            addConstraint(widthAnchor.constraint(equalToConstant: space))
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
