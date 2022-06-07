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
    var height: CGFloat { get }
}

extension Field {
    public var height: CGFloat { 44 }
}

public protocol ModifiableFields: AnyObject {
    func modifiableFields() -> [Field]
}

open class FormView: UIView {
    
    private let editItemsTable = AutoSizedTableView()
    
    public override var intrinsicContentSize: CGSize {
        setNeedsLayout()
        layoutIfNeeded()
//        return editItemsTable.contentSize
        
        return fields.reduce(CGSize.zero) { (previous: CGSize, field: Field) -> CGSize in
            return CGSize(width: editItemsTable.contentSize.width, height: previous.height + field.height)
        }
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
        
        backgroundColor = .clear
        editItemsTable.backgroundColor = .clear
        
        for field in fields {
            editItemsTable.register(field.cellClass, forCellReuseIdentifier: field.identifier)
        }
        
        editItemsTable.delegate = self
        editItemsTable.dataSource = self
        
        editItemsTable.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 0)))
        editItemsTable.separatorStyle = .none
        editItemsTable.isScrollEnabled = true
        editItemsTable.bounces = false
        editItemsTable.showsVerticalScrollIndicator = false
        editItemsTable.showsHorizontalScrollIndicator = false
        editItemsTable.sectionHeaderHeight = 0
        editItemsTable.backgroundColor = .clear
        
        // Used in calculation of editItemsTable.contentSizeeditItemsTable.contentSize.
//        editItemsTable.estimatedRowHeight = UITableView.automaticDimension
        
//        editItemsTable.flashScrollIndicators()
        
        self.addSubview(editItemsTable)
        self.constrainSubviewToBounds(editItemsTable)
        
        editItemsTable.reloadData()
        
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
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let field = fields[indexPath.row]
        return field.height
    }
}

//extension FormViewController: ExternalApplicationRequestDelegate {
//    func requestMapApplication(forCoordinate coordinate: Coordinate) {
//        self.delegate?.requestMapApplication(forCoordinate: coordinate)
//    }
//}
