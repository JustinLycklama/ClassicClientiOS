//
//  SignatureViewController.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-24.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

protocol SignatureDelegate {
    func save()
    func cancel()
}

class SignatureViewController: UIViewController {

    let cancelButton = UIButton()
    let clearButton = UIButton()
    let signButton = UIButton()
    
    let buttonView = UIView()
    let drawingView = DrawingView()
    
    var delegate: SignatureDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = []
                
        // Setup Button View
        for button in [cancelButton, clearButton, signButton] {
            button.translatesAutoresizingMaskIntoConstraints = false
            buttonView.addSubview(button)
            
            button.layer.cornerRadius = 8
            button.titleLabel?.font = CCStyle.fontWithSize(size: 18)
        }
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = CCStyle.cancelButtonBackgroundColor
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        clearButton.setTitle("Clear", for: .normal)
        clearButton.backgroundColor = CCStyle.accentButtonBackgroundColor
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
        
        signButton.setTitle("Sign", for: .normal)
        signButton.backgroundColor = CCStyle.acceptButtonBackgroundColor
        signButton.addTarget(self, action: #selector(sign), for: .touchUpInside)
        
        let views = ["cancel" : cancelButton, "clear" : clearButton, "sign" : signButton, "view": buttonView, "draw": drawingView]
        let metrics = ["buttonWidth" : 75]
        
        let horConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[cancel(buttonWidth)]-(>=0)-[clear(buttonWidth)]-(>=0)-[sign(buttonWidth)]-(0)-|", options: .alignAllCenterY, metrics: metrics, views: views)
                                    
        let verCancel = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[cancel]-(0)-|", options: .alignAllCenterX, metrics: nil, views: views)
        let verClear = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[clear]-(0)-|", options: .alignAllCenterX, metrics: nil, views: views)
        let verSign = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[sign]-(0)-|", options: .alignAllCenterX, metrics: nil, views: views)
                            
        let center = NSLayoutConstraint.init(item: clearButton, attribute: .centerX, relatedBy: .equal, toItem: buttonView, attribute: .centerX, multiplier: 1, constant: 0)
        
        for constraints in [horConstraints, verCancel, verClear, verSign, [center]] {
            buttonView.addConstraints(constraints)
        }
                
        // Setup Main View
        for view in [buttonView, drawingView] {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        drawingView.addBorder(edges: [.top, .bottom])
        
        let verConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(24)-[view(50)]-(16)-[draw]-(32)-|", options: .alignAllCenterX, metrics: nil, views: views)
        
        let horView = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[view]-(16)-|", options: .alignAllCenterY, metrics: nil, views: views)
        let horDraw = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[draw]-(0)-|", options: .alignAllCenterY, metrics: nil, views: views)

        for constraints in [verConstraints, horView, horDraw] {
            self.view.addConstraints(constraints)
        }
        
        view.backgroundColor = .white
    }
    
    @objc func cancel() {
        delegate?.cancel()
    }
    
    @objc func clear() {
        drawingView.clear()
    }
    
    @objc func sign() {
        delegate?.save()
    }


}
