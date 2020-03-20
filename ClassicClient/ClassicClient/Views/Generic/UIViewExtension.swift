//
//  UIViewExtension.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-20.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

extension UIView {
    func constrainSubviewToBounds(_ subview: UIView, withInset inset: UIEdgeInsets = UIEdgeInsets.zero) {
        // subview must be a subview of our cell to be constrained
        if self.subviews.contains(subview) == false {
            return
        }
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        var clingConstraints = [NSLayoutConstraint]()
        
        clingConstraints += [NSLayoutConstraint.init(item: subview, attribute: .trailing, relatedBy:.equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -inset.right)]
        clingConstraints += [NSLayoutConstraint.init(item: subview, attribute: .bottom, relatedBy:.equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -inset.bottom)]
        clingConstraints += [NSLayoutConstraint.init(item: subview, attribute: .top, relatedBy:.equal, toItem: self, attribute: .top, multiplier: 1, constant: inset.top)]
        clingConstraints += [NSLayoutConstraint.init(item: subview, attribute: .leading, relatedBy:.equal, toItem: self, attribute: .leading, multiplier: 1, constant: inset.left)]
        
        NSLayoutConstraint.activate(clingConstraints)
    }
}
