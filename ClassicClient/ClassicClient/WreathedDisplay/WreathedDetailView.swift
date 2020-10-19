//
//  WreathedDisplayView.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-08-26.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

open class WreathedDetailView: UIView {

    public static let CornerRaduis: CGFloat = 10
    
    public required init() {
        super.init(frame: .zero)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    open func initialize() {
        backgroundColor = .green
        self.layer.cornerRadius = WreathedDetailView.CornerRaduis
    }
    
    open func completeTransition() {

    }
    
    open func setTitle(_ title: String) {
        
    }
}
