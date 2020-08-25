//
//  HorizontalItemDetailViewController.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-08-12.
//

import UIKit

class HorizontalItemDetailViewController: UIViewController {

    let detailView = UIView()
    
    public let itemViewMetrics = ["hPadding" : 12]
    
//    public let vertContext = LayoutConstraintContext(visualString: "V:|", options: , mertics: )
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let vertConstraints =
        
        
        
    }
}

struct LayoutConstraintContext {
    let visualString: String
    let options: NSLayoutConstraint.FormatOptions
    let mertics: [String : Any]?
}

extension NSLayoutConstraint {
    func constraints(givenContext context:LayoutConstraintContext, forView view: UIView) -> [NSLayoutConstraint] {
        let views = ["view" : view]
        
        return NSLayoutConstraint.constraints(withVisualFormat: context.visualString, options: context.options, metrics: context.mertics, views: views)
    }
}
