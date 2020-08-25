//
//  LoadingView.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-19.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

public class LoadingView: UIViewController {
    
    private let kRotationAnimationKey = "rotationanimationkey"
    
    let loadingIcon = UIImageView()
    let iconView = UIImageView()
    let touchBlocker = UIView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        
        for view in [touchBlocker, iconView] {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }

        loadingIcon.image = UIImage(named: "loading", in: Bundle(for: type(of:self)), compatibleWith: nil)
        loadingIcon.translatesAutoresizingMaskIntoConstraints = false
        
        iconView.addSubview(loadingIcon)
        iconView.constrainSubviewToBounds(loadingIcon)
        iconView.backgroundColor = .clear
                    
        touchBlocker.backgroundColor = UIColor.gray.withAlphaComponent(0.35)
        touchBlocker.isUserInteractionEnabled = true
        self.view.constrainSubviewToBounds(touchBlocker)
        
        let centerX = NSLayoutConstraint.init(item: iconView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint.init(item: iconView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)

        let width = NSLayoutConstraint.init(item: iconView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 125)
        let height = NSLayoutConstraint.init(item: iconView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 125)
        
        self.view.addConstraints([centerX, centerY, width, height])

        self.view.alpha = 0
        setLoading(false)
    }
     
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                        
        if iconView.layer.animation(forKey: kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")

            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = 2.0
            rotationAnimation.repeatCount = Float.infinity

            loadingIcon.layer.add(rotationAnimation, forKey: kRotationAnimationKey)
        }
    }
    
    deinit {
        loadingIcon.layer.removeAllAnimations()
    }
    
    public func setLoading(_ loading: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = loading ? 1 : 0
        }
    }
    
    public func setError(error: NSError) {
        // Here I would be hiding the spinner and displaying some message for the user
    }
}
