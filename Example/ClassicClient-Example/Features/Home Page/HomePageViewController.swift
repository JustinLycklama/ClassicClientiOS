//
//  HomePageViewController.swift
//  ClassicClient-Example
//
//  Created by Justin Lycklama on 2024-03-16.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    
    private lazy var titleLabel: UIView = {
        let label = UILabel()
        label.text = "Classic Client"
        label.font = FontBook.font(.medium, withSize: 18)
        label.textColor = Style.headerTextColor
        label.textAlignment = .center
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        let stack = UIStackView(arrangedSubviews: [titleLabel])
        view.constrainViewSafeArea(stack)
        
        view.borderColor = .blue
        view.borderWidth = 2
    }
    
}
