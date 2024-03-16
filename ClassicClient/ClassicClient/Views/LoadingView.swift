//
//  LoadingView.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-19.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import Combine

/// Virtual class, cannot be initialized. Look to subviews for concrete implementations
public class LoadingView: UIView {
    private let ANIMATION_DURATION = TimeInterval(0.33)
    
    // Virtual variable
    fileprivate var loadingIndicator: CustomIndicator {
        get {
            print("FATAL: LoadingView is a Virtual Class")
            exit(EXIT_FAILURE)
        }
    }
    
    private var loadingCounter = 0 {
        didSet {
            isVisible.send(loadingCounter != 0)
        }
    }
    
    private let isVisible = CurrentValueSubject<Bool, Never>(false)

    private var subscriptions = Set<AnyCancellable>()
    private var loadingSubscriptions = Set<AnyCancellable>()
    
    public init() {
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init(coder: NSCoder) {
        super.init(frame: .zero)
        
        initialize()
    }
    
    fileprivate func initialize() {
        self.backgroundColor = .clear
        
        self.isHidden = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(loadingIndicator)
        self.centerSubview(loadingIndicator)
                
        isVisible
            .removeDuplicates()
            .sink { [weak self] visible in
                guard let self = self else {
                    return
                }
     
                self.isHidden = !visible
                
                if visible {
                    self.loadingIndicator.startAnimating()
                } else {
                    self.loadingIndicator.stopAnimating()
                }
            }.store(in: &subscriptions)
    }
    
    func prepareForView(_ view: UIView) {
        view.addSubview(self)
        view.constrainView(self)

        view.bringSubviewToFront(self)
    }
    
    func bindTo(_ loadingState: LoadingState) {
        // End any old loading subscriptions, only one binding should be active at once
        loadingSubscriptions = Set<AnyCancellable>()
        
        loadingState.$isLoading.sink { [weak self] isLoading in
            self?.setIsLoading(isLoading)
        }.store(in: &loadingSubscriptions)
    }
    
    // Start and stop loading have been deprecated with the introduction of LoadingState
    func startLoading() {
        loadingCounter += 1
    }
    
    func stopLoading() {
        loadingCounter -= 1
    }
    
    func setIsLoading(_ isLoading: Bool) {
        loadingCounter = isLoading ? 1 : 0
    }
}

// MARK: Implentations

public class SpinnerLoadingView: LoadingView {
    
    private let activityIndicator = UIActivityIndicatorView()
    override var loadingIndicator: CustomIndicator {
        get {
            activityIndicator
        }
    }
}

public class CloudLoadingView: LoadingView {
    
    private let cloudIndicator = PulsingIndicator(frame: .zero,
                                                  image: UIImage(named: "download") ?? UIImage(),
                                                  fromValue: 0.01,
                                                  toValue: 0.55,
                                                  duration: 0.9)
    
    override var loadingIndicator: CustomIndicator {
        get {
            cloudIndicator
        }
    }
    
    override func initialize() {
        super.initialize()
        
        loadingIndicator.addConstraint(NSLayoutConstraint.init(item: loadingIndicator, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 12))

        loadingIndicator.addConstraint(NSLayoutConstraint.init(item: loadingIndicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 12))
    }
}

// MARK: Custom Indicators

protocol CustomIndicator: UIView {
    func startAnimating()
    func stopAnimating()
}

extension UIActivityIndicatorView: CustomIndicator {}

class PulsingIndicator: UIView, CustomIndicator {
    
    let imageView = UIImageView()
    
    let fromValue: CGFloat
    let toValue: CGFloat
    let duration: CGFloat
    
    init(frame: CGRect, image: UIImage, fromValue: CGFloat = 0.01, toValue: CGFloat = 1, duration: CGFloat = 0.7) {
        self.fromValue = fromValue
        self.toValue = toValue
        self.duration = duration
        
        super.init(frame: frame)
        
        imageView.frame = bounds
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(imageView)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    private let blinkAnimationKey = "PulseAnimation"
    func startAnimating() {
        stopAnimating()
        
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = duration
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.isRemovedOnCompletion = false   //Set this property to false.
        self.layer.add(animation, forKey: blinkAnimationKey)
    }
    
    func stopAnimating() {
        self.layer.removeAnimation(forKey: blinkAnimationKey)
        self.alpha = 0
    }
}
