//
//  UIViewExtension.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-20.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

extension UIView {
    
    // Used when the view being wrapped has an intrinsic content size and does not need to be contrained on all edges
    func wrappedInView(xAlignment: Alignment = .center, yAlignment: Alignment = .center) -> UIView {
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(self)
        
        switch xAlignment {
        case .leading:
            container.addConstraint(self.leadingAnchor.constraint(equalTo: container.leadingAnchor))
        case .trailing:
            container.addConstraint(self.trailingAnchor.constraint(equalTo: container.trailingAnchor))
        case .center:
            container.addConstraint(self.centerXAnchor.constraint(equalTo: container.centerXAnchor))
        }
        
        switch yAlignment {
        case .leading:
            container.addConstraint(self.topAnchor.constraint(equalTo: container.topAnchor))
        case .trailing:
            container.addConstraint(self.bottomAnchor.constraint(equalTo: container.bottomAnchor))
        case .center:
            container.addConstraint(self.centerYAnchor.constraint(equalTo: container.centerYAnchor))
        }
                
        container.addConstraint(container.widthAnchor.constraint(greaterThanOrEqualTo: self.widthAnchor))
        container.addConstraint(container.heightAnchor.constraint(greaterThanOrEqualTo: self.heightAnchor))
        
        return container
    }
    
    func constrainedInView(onEdges edges: [Edge] = .all,
                           withInsets insets: UIEdgeInsets = .zero,
                           ofSize size: CGSize? = nil) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(self)
        container.constrainView(self, onEdges: edges, withInsets: insets)
        
        if let size {
            container.addConstraint(container.widthAnchor.constraint(equalToConstant: size.width))
            container.addConstraint(container.heightAnchor.constraint(equalToConstant: size.height))
        }
        
        return container
    }
    
    func wrapInScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        let scrollContentView = UIView()
        scrollView.addSubview(scrollContentView)
        scrollView.constrainView(scrollContentView)
        scrollView.addConstraints([
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        scrollContentView.addSubview(self)
        scrollContentView.constrainView(self)
        
        return scrollView
    }
}

// MARK: Constraining Subviews

extension UIView {
    
    @discardableResult
    public func constrainView(_ view: UIView,
                       onEdges edges: [Edge] = .all,
                       withInsets insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        
        if !subviews.contains(view) {
            self.addSubview(view)
        }
        
        var constrains: [NSLayoutConstraint] = []
        
        if edges.contains(.top) {
            constrains.append(view.topAnchor.constraint(equalTo: self.topAnchor, constant: insets.top))
        }
        
        if edges.contains(.bottom) {
            constrains.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -insets.bottom))
        }
        
        if edges.contains(.left) {
            constrains.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: insets.left))
        }
        
        if edges.contains(.right) {
            constrains.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -insets.right))
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
        
        return constrains
    }
    
    public func centerSubview(_ subview: UIView,
                       verticalOffset: CGFloat = 0,
                       horizontalOffset: CGFloat = 0,
                       requiresSizeConstraints: Bool = true) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        if !subviews.contains(subview) {
            self.addSubview(subview)
        }
        
        let centerX = NSLayoutConstraint.init(item: subview, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: horizontalOffset)
        
        let centerY = NSLayoutConstraint.init(item: subview, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: verticalOffset)
        
        let width = widthAnchor.constraint(greaterThanOrEqualTo: subview.widthAnchor, multiplier: 1)
        let height = heightAnchor.constraint(greaterThanOrEqualTo: subview.heightAnchor, multiplier: 1)
        
        var constraints = [centerX, centerY]
        
        if requiresSizeConstraints {
            constraints += [width, height]
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    public func constrainViewSafeArea(_ view: UIView,
                               onEdges edges: [Edge] = .all,
                               withInsets insets: UIEdgeInsets = .zero) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if !subviews.contains(view) {
            self.addSubview(view)
        }
        
        var constraints: [NSLayoutConstraint] = []
        
        let margins = self.layoutMarginsGuide
        
        if edges.contains(.top) {
            constraints.append(view.topAnchor.constraint(equalTo: margins.topAnchor, constant: insets.top))
        }
        
        if edges.contains(.bottom) {
            constraints.append(view.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -insets.bottom))
        }
        
        if edges.contains(.left) {
            constraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: insets.left))
        }
        
        if edges.contains(.right) {
            constraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -insets.right))
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @discardableResult
    public func sized(_ size: CGSize, withPriority priority: UILayoutPriority = .required) -> Self {
        let width = widthAnchor.constraint(equalToConstant: size.width)
        width.priority = priority
        
        let height = heightAnchor.constraint(equalToConstant: size.height)
        height.priority = priority
        
        addConstraint(width)
        addConstraint(height)
        return self
    }
}

// MARK: TapGestureRecognizer

extension UIView {
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    @discardableResult
    public func addTapGestureRecognizer(action: (() -> Void)?) -> UITapGestureRecognizer {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
        return tapGestureRecognizer
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
}

// MARK: Round Corners

extension UIView {
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
    }
}

// MARK: Animate Border
extension UIView {
    public func animateBorderColor(toColor: UIColor, duration: Double) {
        let animation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = layer.borderColor
        animation.toValue = toColor.cgColor
        animation.duration = duration
        layer.add(animation, forKey: "borderColor")
        layer.borderColor = toColor.cgColor
    }
}
