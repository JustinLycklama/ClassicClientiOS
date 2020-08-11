//
//  ItemQuantityViewController.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-23.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import  ClassicClient

protocol ItemUpdateDelegate {
    func itemUpdated(item: Item)
}

class ItemQuantityViewController: UIViewController, QuantityEditorDelegate {
        
    let itemNameHeader = UILabel()
    let quantityLabel = UILabel()
    
    let quantityEditor = QuantityEditorView()
    
    var item: Item
    var delegate: ItemUpdateDelegate?
    
    init(withItem item: Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = []
        navigationController?.navigationBar.isTranslucent = false
        
        title = "Edit Item"
        
        for view in [itemNameHeader, quantityLabel, quantityEditor] {             
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
         
        quantityLabel.text = "Quantity:"
        quantityLabel.font = CCStyle.fontWithSize(size: 13)
        
        itemNameHeader.text = item.name
        itemNameHeader.font = CCStyle.fontWithSize(size: 18, andType: .title)
        
        quantityEditor.delegate = self
        updateCollectionValue()
        
        let views = ["header" : itemNameHeader, "qlabel" : quantityLabel, "editor" : quantityEditor]
         
         let verConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(16)-[header]-(32)-[qlabel]-(4)-[editor(50)]", options: .alignAllCenterX, metrics: nil, views: views)
                    
         let horHeader = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[header]", options: .alignAllCenterY, metrics: nil, views: views)
         let horLabel = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[qlabel]", options: .alignAllCenterY, metrics: nil, views: views)
         let horEditor = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(8)-[editor]-(8)-|", options: .alignAllCenterY, metrics: nil, views: views)
        
         for constraints in [verConstraints,  horHeader, horLabel, horEditor] {
            self.view.addConstraints(constraints)
         }
        
        self.view.backgroundColor = .white
        
        let barButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        navigationItem.setRightBarButton(barButton, animated: false)
    }
        
    @objc func save() {
        delegate?.itemUpdated(item: item)
    }
    
    func updateCollectionValue(withDelta delta: Int = 0) {
        item.count += delta
        quantityEditor.setValue(value: item.count)
    }
    
    // MARK: QuantityEditorDelegate
    func minusPressed(onEditor: QuantityEditorView) {
        updateCollectionValue(withDelta: -1)
    }
    
    func plusPressed(onEditor: QuantityEditorView) {
        updateCollectionValue(withDelta: 1)
    }
    
}
