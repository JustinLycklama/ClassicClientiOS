//
//  LocationItemsViewController.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-19.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

class LocationItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ItemUpdateDelegate {

    struct Constants {
        static let DefaultCell = "defaultCell"
    }
    
    let tableview = UITableView.init(frame: .zero, style: .plain)
    let location: Location
    
    var items: [Item]?
    
    init(forLocation location: Location) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.DefaultCell)
                    
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(tableview)
        self.view.constrainSubviewToBounds(tableview)
        
        tableview.reloadData()
        
        ItemViewModel.sharedInstance.getItems(forLocationId: location.id) { [weak self] (result: Result<Item>) in
            
            switch result {
            case .success(let items):
                self?.items = items
                break
            case .error(let err):
                
                break
            }
            
            self?.tableview.reloadData()
        }
    }
        
    // MARK: Tableview Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.DefaultCell, for: indexPath) as! ItemTableViewCell
        
        let item = items![indexPath.row]
        cell.setItem(item: item)
        
//        cell.delegate = self
//        cell.setLocation(location: cityLocations[indexPath.row])
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items![indexPath.row]
        let editorVC = ItemQuantityViewController(withItem: item)
                    
        editorVC.delegate = self
        
        navigationController?.pushViewController(editorVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: ItemUpdateDelegate
    func itemUpdated(item: Item) {
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] () in
            guard let self = self else {
               return
            }
            
            if let indexOfItem = self.items?.firstIndex(of: item) {
                self.items?[indexOfItem] = item
                
                let indexPath = IndexPath(row: indexOfItem, section: 0)
                self.tableview.reloadRows(at: [indexPath], with: .fade)
            }
        }

        navigationController?.popViewController(animated: true)
        CATransaction.commit()
    }
}
