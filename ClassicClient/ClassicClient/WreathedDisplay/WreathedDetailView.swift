//
//  WreathedDisplayView.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-08-26.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

public class WreathedDetailView: UIView {

    public static let CornerRaduis: CGFloat = 10
    
    init() {
        super.init(frame: .zero)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        backgroundColor = .green
        self.layer.cornerRadius = WreathedDetailView.CornerRaduis
    }
}
