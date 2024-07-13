//
//  CustomTabbar.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-15.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import Foundation

import UIKit
import Combine

open class HighlightedTabbar: CustomTabbar {
    
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var selectedTabIndicator: UIView = {
        let view = UIView().sized(.init(width: 50, height: 5))
        view.backgroundColor = .red
        view.roundCorners([.bottomLeft, .bottomRight], radius: 5)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let separatorColor: UIColor
    
    public init(separatorColor: UIColor) {
        self.separatorColor = separatorColor
        
        super.init(frame: .zero)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutView() {
        super.layoutView()
        
        constrainView(Separator(.horizontal, color: separatorColor), onEdges: [.left, .top, .right])
        
        let indicator = selectedTabIndicator
        var indicatorXConstraint: NSLayoutConstraint = indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        
        addSubview(indicator)
        addConstraint(indicator.topAnchor.constraint(equalTo: topAnchor))
        addConstraint(indicatorXConstraint)
        
        $selectedIndex.sink { [weak self] index in
            guard let self = self else {
                return
            }
            
            let items = items
            UIView.animate(withDuration: 0.33, delay: 0, options: [.curveEaseOut]) {
                self.removeConstraint(indicatorXConstraint)
                
                if let index, index < items.count {
                    indicatorXConstraint = indicator.centerXAnchor.constraint(equalTo: items[index].centerXAnchor)
                } else {
                    indicatorXConstraint = indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
                }
                
                self.addConstraint(indicatorXConstraint)
                self.layoutIfNeeded()
            }
            
        }.store(in: &subscriptions)
    }
}

open class CustomTabbar: UIView {
    
    weak var actionDelegate: CustomTabbarActionDelegate?
    
    private(set) public var items: [CustomTabItem] = [] {
        didSet {
            stack.arrangedSubviews.forEach({$0.removeFromSuperview()})
            items.forEach({stack.addArrangedSubview($0)})
            
            if items.count >= 1 {
                selectedIndex = 0
            }
        }
    }
    
    @Published private(set) var selectedIndex: Int?
    
    private let stack = UIStackView()
    
    private var subscriptions = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutView() {
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        constrainView(stack)
    }
    
    func setIndex(_ index: Int) {
        guard index < items.count else {
            return
        }
        
        selectedIndex = index
    }
    
    // MARK: Tabs
    
    func setNumberOfTabs(_ tabCount: Int) {
        var currentTabs = items
        while tabCount < currentTabs.count {
            currentTabs.removeLast()
        }
        
        while tabCount > currentTabs.count {
            let tabItem = CustomTabItem(frame: .zero)
            let index = currentTabs.count
            
            tabItem.addTapGestureRecognizer { [unowned self] in
                actionDelegate?.itemTapped(index)
            }
            
            $selectedIndex.sink { selectedIndex in
                tabItem.setSelected(index == selectedIndex)
            }.store(in: &subscriptions)
            
            currentTabs.append(tabItem)
        }
        
        items = currentTabs
    }
    
    func setTab(_ tab: CustomTabItem, forIndex index: Int) {
        guard index < items.count else {
            return
        }
        
        var currentTabs = items
        currentTabs.remove(at: index)
        currentTabs.insert(tab, at: index)
        items = currentTabs
    }
}
