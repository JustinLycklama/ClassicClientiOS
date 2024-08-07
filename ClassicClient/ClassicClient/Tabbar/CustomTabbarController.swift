//
//  CCTabbarController.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-15.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import UIKit
import Combine

protocol CustomTabbarActionDelegate: AnyObject {
    func itemTapped(_ index: Int)
}

open class CustomTabbarController: UITabBarController, CustomTabbarActionDelegate {

    public let customTabbar: CustomTabbar
    
    open override var viewControllers: [UIViewController]? {
        didSet {
            customTabbar.setNumberOfTabs(viewControllers?.count ?? 0)
        }
    }
    
    open override var selectedIndex: Int {
        didSet {
            customTabbar.setIndex(selectedIndex)
        }
    }
    
    public init(tabbar: CustomTabbar) {
        self.customTabbar = tabbar
        super.init(nibName: nil, bundle: nil)
        
        customTabbar.actionDelegate = self
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
                
        view.addSubview(customTabbar)
        view.constrainViewSafeArea(customTabbar, onEdges: [.left, .bottom, .right])
        view.addConstraint(customTabbar.topAnchor.constraint(equalTo: tabBar.topAnchor))

        customTabbar.backgroundColor = .white
    }
    
    // MARK: - Bindings
    
    func itemTapped(_ index: Int) {
        guard index < viewControllers?.count ?? 0,
        let controller = viewControllers?[index] else {
            return
        }
        
        if delegate?.tabBarController?(self, shouldSelect: controller) ?? true {
            selectedIndex = index
        }
    }
}
