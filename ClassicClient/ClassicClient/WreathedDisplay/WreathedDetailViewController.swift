//
//  HorizontalItemDetailViewController.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-08-12.
//

import UIKit

open class WreathedDetailViewController: UIViewController {

    open var viewType: WreathedDetailView.Type {
        return WreathedDetailView.self
    }
    
    public var detailView: WreathedDetailView!
        
    public static let constraintEdges = UIEdgeInsets(top: 64, left: 32, bottom: 32, right: 32)
    public static let constraintContext = LayoutConstraintContext(horizontalVisualString: "H:|-(left)-[view]-(right)-|",
                                                                      verticalVisualString: "V:|-(top)-[view]-(bottom)-|",
                                                                      options: [],
                                                                      edgeInsets: constraintEdges)
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        detailView = viewType.init()
        self.edgesForExtendedLayout = []
        
        detailView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(detailView)
        view.addConstraints(NSLayoutConstraint.constraints(givenContext: WreathedDetailViewController.constraintContext,
                                                           forView: detailView))
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseInOut, animations: {
            self.detailView.completeTransition()

        }) { (completed: Bool) in
            
        }
    }
}

public struct LayoutConstraintContext {
    let horizontalVisualString: String
    let verticalVisualString: String

    let options: NSLayoutConstraint.FormatOptions
    let edgeInsets: UIEdgeInsets
}

extension NSLayoutConstraint {
    static func constraints(givenContext context:LayoutConstraintContext, forView view: UIView) -> [NSLayoutConstraint] {
        let views = ["view" : view]
        
        let metrics = ["top" : context.edgeInsets.top,
                       "bottom" : context.edgeInsets.bottom,
                       "left" : context.edgeInsets.left,
                       "right" : context.edgeInsets.right]
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: context.horizontalVisualString, options: context.options, metrics: metrics, views: views)
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: context.verticalVisualString, options: context.options, metrics: metrics, views: views)
        
        return horizontalConstraints + verticalConstraints
    }
}
