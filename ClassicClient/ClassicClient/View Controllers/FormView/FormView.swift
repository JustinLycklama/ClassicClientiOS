//
//  FormViewController.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-12-14.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

public protocol Field {
    var identifier: String { get }
    var cellClass: UITableViewCell.Type { get }
    
    func configureCell(_ cell: UITableViewCell)
}

open class FormView: UIView {
    
    private let editItemsTable = AutoSizedTableView()
    
    public override var intrinsicContentSize: CGSize {
        setNeedsLayout()
        layoutIfNeeded()
        return editItemsTable.contentSize
    }
    
    let fields: [Field]
    
    public init(fields: [Field]) {
        self.fields = fields
        
        super.init(frame: .zero)
        
        setup()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        backgroundColor = .white
        
        for field in fields {
            editItemsTable.register(field.cellClass, forCellReuseIdentifier: field.identifier)
        }
        
        editItemsTable.delegate = self
        editItemsTable.dataSource = self
        
        editItemsTable.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: Classic.style.formPadding)))
        editItemsTable.separatorStyle = .none
        editItemsTable.isScrollEnabled = true
        editItemsTable.bounces = false
        editItemsTable.showsVerticalScrollIndicator = true
        editItemsTable.sectionHeaderHeight = Classic.style.formPadding
        editItemsTable.backgroundColor = .clear
        
        editItemsTable.flashScrollIndicators()
        
        self.addSubview(editItemsTable)
        self.constrainSubviewToBounds(editItemsTable)
        
        editItemsTable.reloadData()
        editItemsTable.layoutIfNeeded()
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
}

extension FormView: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = fields[indexPath.row]
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: field.identifier, for: indexPath)
        
        field.configureCell(cell)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}

//extension FormViewController: ExternalApplicationRequestDelegate {
//    func requestMapApplication(forCoordinate coordinate: Coordinate) {
//        self.delegate?.requestMapApplication(forCoordinate: coordinate)
//    }
//}
