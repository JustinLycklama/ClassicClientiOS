//
//  HorizontalItemDetailViewController.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-08-12.
//

import UIKit

open class WreathedDetailViewController: UIViewController {

    public let detailView = WreathedDetailView()
    
//    public let itemViewMetrics = ["hPadding" : 12]
    
    public static let constraintEdges = UIEdgeInsets(top: 64, left: 64, bottom: 64, right: 64)
    public static let constraintContext = LayoutConstraintContext(horizontalVisualString: "H:|-(left)-[view]-(right)-|",
                                                                      verticalVisualString: "V:|-(top)-[view]-(bottom)-|",
                                                                      options: [],
                                                                      edgeInsets: constraintEdges)
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.edgesForExtendedLayout = []

//        let vertConstraints = NSLayoutConstraint.with
        
        detailView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(detailView)
        view.addConstraints(NSLayoutConstraint.constraints(givenContext: WreathedDetailViewController.constraintContext,
                                                           forView: detailView))
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
