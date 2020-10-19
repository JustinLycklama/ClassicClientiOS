//
//  UIViewExtension.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-20.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

public extension UIView {
    func constrainSubviewToBounds(_ subview: UIView, onEdges edges: UIRectEdge = .all, withInset inset: UIEdgeInsets = UIEdgeInsets.zero) {
        // subview must be a subview of our cell to be constrained
        if self.subviews.contains(subview) == false {
            return
        }
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        var clingConstraints = [NSLayoutConstraint]()
        
        if edges.contains(.bottom) {
            clingConstraints += [NSLayoutConstraint.init(item: subview, attribute: .bottom, relatedBy:.equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -inset.bottom)]
        }
        
        if edges.contains(.top) {
            clingConstraints += [NSLayoutConstraint.init(item: subview, attribute: .top, relatedBy:.equal, toItem: self, attribute: .top, multiplier: 1, constant: inset.top)]
        }
        
        if edges.contains(.left) {
            clingConstraints += [NSLayoutConstraint.init(item: subview, attribute: .leading, relatedBy:.equal, toItem: self, attribute: .leading, multiplier: 1, constant: inset.left)]
        }
        
        if edges.contains(.right) {
            clingConstraints += [NSLayoutConstraint.init(item: subview, attribute: .trailing, relatedBy:.equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -inset.right)]
        }
        
        NSLayoutConstraint.activate(clingConstraints)
    }
    
    @discardableResult
    func addBorder(edges: UIRectEdge, color: UIColor = UIColor.gray, thickness: CGFloat = 1.0) -> [UIView] {
        
        var borders = [UIView]()
        
        func border() -> UIView {
            let border = UIView(frame: CGRect.zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        
        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["top": top]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["top": top]))
            borders.append(top)
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["left": left]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["left": left]))
            borders.append(left)
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["right": right]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["right": right]))
            borders.append(right)
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["bottom": bottom]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bottom]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["bottom": bottom]))
            borders.append(bottom)
        }
        
        return borders
    }
    
    class func instanceFromNib(_ xibName: String, inBundle bundle:Bundle) -> UIView {
        return UINib(nibName: xibName, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}

public extension UIImage {
    var roundedImage: UIImage? {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)

        UIBezierPath(
            roundedRect: rect,
            cornerRadius: 10
            ).addClip()

        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

public protocol Loadable: AnyObject {
    var loadingView: LoadingView? { get set }
}

public extension Loadable where Self: UIViewController {
    func addLoadingView() {
        let lView = LoadingView()
        
        self.addChild(lView)
        self.view.addSubview(lView.view)
        self.view.constrainSubviewToBounds(lView.view)
        self.view.bringSubviewToFront(lView.view)
        
        loadingView = lView
    }
}
