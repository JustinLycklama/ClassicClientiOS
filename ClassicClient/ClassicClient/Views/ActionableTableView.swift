//
//  AddableSectionTableController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-01-07.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit

public struct SwipeActionConfig<Type> {
    let image: UIImage?
    let performAction: ((Type) -> Void)
    
    public init(image: UIImage?, performAction: @escaping ((Type) -> Void)) {
        self.image = image
        self.performAction = performAction
    }
}

public struct TableCellConfig<Type, Cell> {
    let configure: ((Type, Cell) -> Void)?
    let performAction: ((Type) -> Void)?
    let swipeActions: [SwipeActionConfig<Type>]
    
    public init(swipeActions: [SwipeActionConfig<Type>] = [],
                configure: ((Type, Cell) -> Void)? = nil,
                performAction: ((Type) -> Void)?) {
        self.configure = configure
        self.performAction = performAction
        self.swipeActions = swipeActions
    }
}

public class ActionableTableView<T,
                                 ItemCell: UITableViewCell,
                                 ActionCell: UITableViewCell>: UIView, UITableViewDelegate, UITableViewDataSource {

    private let ItemCellIdentifier = "ItemCell"
    private let ActionCellIdentifier = "ActionCell"
    
    private let tableView = UITableView()
    
    private var items: [T] = []
    
    public var canPerformAction = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var actionConfig: TableCellConfig<Void, ActionCell>
    private var itemConfig: TableCellConfig<T, ItemCell>
    
    public init(actionConfig: TableCellConfig<Void, ActionCell>, itemConfig: TableCellConfig<T, ItemCell>) {
        self.actionConfig = actionConfig
        self.itemConfig = itemConfig

        super.init(frame: .zero)
        
        self.clipsToBounds = false
        self.layer.cornerRadius = Classic.style.cornerRadius
        self.backgroundColor = .clear
        
        let maskingView = UIView()
        maskingView.clipsToBounds = true
        
        self.addSubview(maskingView)
        self.constrainSubviewToBounds(maskingView, withInset: UIEdgeInsets(top: -Classic.style.interiorMargin,
                                                                           left: -Classic.style.interiorMargin,
                                                                           bottom: -Classic.style.interiorMargin,
                                                                           right: -Classic.style.interiorMargin))
        
        maskingView.addSubview(tableView)
        maskingView.constrainSubviewToBounds(tableView, withInset: UIEdgeInsets(top: Classic.style.interiorMargin,
                                                                                left: Classic.style.interiorMargin,
                                                                                bottom: Classic.style.interiorMargin,
                                                                                right: Classic.style.interiorMargin))
        
        // Table
        tableView.register(ActionCell.self, forCellReuseIdentifier: ActionCellIdentifier)
        tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCellIdentifier)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.clipsToBounds = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setItems(items: [T]) {
        self.items = items
        tableView.reloadData()
    }
    
    public func item(at indexPath: IndexPath) -> T? {
        if items.count > indexPath.row {
            return items[indexPath.row]
        }
        
        return nil
    }
    
    public func isPerformActionSection(_ section: Int) -> Bool {
        return section == 1 && canPerformAction
    }
    
    public func isPerformActionIndex(_ indexPath: IndexPath) -> Bool {
        return canPerformAction && isPerformActionSection(indexPath.section)
    }
    
    // MARK: - UITableViewDelegate UITableViewDatasource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return canPerformAction ? 2 : 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if canPerformAction && isPerformActionSection(section) {
            return 1
        }
        
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        
        if isPerformActionIndex(indexPath) {
            let actionCell = tableView.dequeueReusableCell(withIdentifier: ActionCellIdentifier, for: indexPath) as! ActionCell
            cell = actionCell
            
            actionConfig.configure?((), actionCell)
        } else {
            let itemCell = tableView.dequeueReusableCell(withIdentifier: ItemCellIdentifier, for: indexPath) as! ItemCell
            cell = itemCell
            
            itemConfig.configure?(items[indexPath.row], itemCell)
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !isPerformActionIndex(indexPath)
    }

    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        var actions: [UIContextualAction] = []

        if isPerformActionIndex(indexPath) {
            for swipeConfig in actionConfig.swipeActions {
                let action = UIContextualAction(style: .destructive, title: "", handler: { [weak self] (action, view, completion: @escaping (Bool) -> Void) in
                    guard let self = self else {
                        completion(false)
                        return
                    }

                    swipeConfig.performAction(())
                    completion(true)
                })

                action.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                action.image = swipeConfig.image
                
                actions.append(action)
            }
        }
        else {
            for swipeConfig in itemConfig.swipeActions {
                let action = UIContextualAction(style: .destructive, title: "", handler: { [weak self] (action, view, completion: @escaping (Bool) -> Void) in
                    guard let self = self else {
                        completion(false)
                        return
                    }

                    swipeConfig.performAction(self.items[indexPath.row])
                    completion(true)
                })

                action.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                action.image = swipeConfig.image
                
                actions.append(action)
            }
        }

        return UISwipeActionsConfiguration(actions: actions)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if isPerformActionIndex(indexPath) {
            actionConfig.performAction?(())
            
        } else {
            itemConfig.performAction?(items[indexPath.row])
        }
    }
}
