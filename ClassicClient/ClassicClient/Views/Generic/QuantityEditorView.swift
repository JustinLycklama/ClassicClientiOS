//
//  QuantityEditorView.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-23.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

public protocol QuantityEditorDelegate {
    func minusPressed(onEditor: QuantityEditorView)
    func plusPressed(onEditor: QuantityEditorView)
}

public class QuantityEditorView: UIView {

    let minusButton = UIButton()
    let plusButton = UIButton()
    
    let textArea = UILabel()
    
    public var delegate: QuantityEditorDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialize()
    }
    
    func initialize()
    {
        for view in [minusButton, plusButton, textArea] {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        minusButton.backgroundColor = App.style.accentButtonBackgroundColor
        plusButton.backgroundColor = App.style.accentButtonBackgroundColor

        minusButton.setTitle(" - ", for: .normal)
        plusButton.setTitle(" + ", for: .normal)
        
        minusButton.addTarget(self, action: #selector(minusPressed), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusPressed), for: .touchUpInside)
        
        textArea.textAlignment = .center
        
        let views = ["minus" : minusButton, "plus" : plusButton, "value" : textArea]
        
        let horConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[minus]-(0)-[value]-(0)-[plus]-(0)-|", options: .alignAllCenterY, metrics: nil, views: views)
        let vertMinus = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[minus]-(0)-|", options: .alignAllCenterX, metrics: nil, views: views)
        let vertPlus = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[plus]-(0)-|", options: .alignAllCenterX, metrics: nil, views: views)
        let vertValue = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[value]-(0)-|", options: .alignAllCenterX, metrics: nil, views: views)

        let ratio = NSLayoutConstraint.init(item: plusButton, attribute: .width, relatedBy: .equal, toItem: plusButton, attribute: .height, multiplier: 1, constant: 0)
        let equality = NSLayoutConstraint.init(item: minusButton, attribute: .width, relatedBy: .equal, toItem: plusButton, attribute: .width, multiplier: 1, constant: 0)

        for constraints in [horConstraints, vertMinus, vertPlus, vertValue, [ratio, equality]] {
            addConstraints(constraints)
        }
        
        addBorder(edges: .all , color: .black, thickness: 1)        
    }
    
    public func setValue(value: Int) {
        textArea.text = String(value)
    }
    
    @objc func minusPressed() {
        delegate?.minusPressed(onEditor: self)
    }
    
    @objc func plusPressed() {
        delegate?.plusPressed(onEditor: self)
    }
}
