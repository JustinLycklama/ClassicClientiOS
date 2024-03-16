//
//  Separator.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-15.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import UIKit

class Separator: UIView {
    init(_ axis: Axis = .horizontal, color: UIColor = .gray, thickness: CGFloat = 1) {
        super.init(frame: .zero)
        
        backgroundColor = color
        
        switch axis {
        case .horizontal:
            addConstraint(heightAnchor.constraint(equalToConstant: thickness))
        case .vertical:
            addConstraint(widthAnchor.constraint(equalToConstant: thickness))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
