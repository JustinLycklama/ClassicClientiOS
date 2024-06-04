//
//  PopoverView.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-04-03.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import UIKit

class PopoverView: UIView {
    
    private let source: UIView
    private let container: UIView
    
    private lazy var backgroundScreen: UIView = {
        let background = UIView()
        background.backgroundColor = .black
        background.alpha = 0.05
        
        background.addTapGestureRecognizer {
            self.dismiss()
        }
        
        return background
    }()
    
    init(_ content: UIView, fromSource source: UIView, inContainer container: UIView) {
        self.source = source
        self.container = container
        
        super.init(frame: .zero)
        
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false

        roundCorners([.bottomLeft, .bottomRight, .topLeft], radius: 8)
        borderColor = .black
        borderWidth = 1
        
        constrainView(content, withInsets: UIEdgeInsets(10))
        
        addTapGestureRecognizer {
            self.dismiss()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func present() {
        container.constrainView(backgroundScreen)
        container.addSubview(self)

        container.addConstraint(self.topAnchor.constraint(equalTo: source.bottomAnchor, constant: 5))
        container.addConstraint(self.trailingAnchor.constraint(equalTo: source.centerXAnchor, constant: -5))
        
        self.alpha = 0
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1
        } completion: { _ in
            self.alpha = 1
        }
    }
    
    func dismiss() {
        backgroundScreen.removeFromSuperview()
        
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}

extension UIView {
    func asPopover(fromSource source: UIView, inContainer container: UIView) -> PopoverView {
        return PopoverView(self, fromSource: source, inContainer: container)
    }
}
