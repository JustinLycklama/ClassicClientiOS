//
//  CustomTabbarItem.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-15.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import UIKit

class CustomTabItem: UIView {
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    var selectedImage: UIImage?
    
    let imageView = UIImageView().sized(.init(width: 20, height: 20))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutView() {
        imageView.contentMode = .scaleAspectFit
        centerSubview(imageView, verticalOffset: 10)
    }
    
    func setSelected(_ selected: Bool) {
        imageView.image = selected ? selectedImage : image
    }
}
