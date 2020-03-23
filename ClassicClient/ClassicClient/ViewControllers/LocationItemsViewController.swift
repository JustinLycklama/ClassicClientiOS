//
//  LocationItemsViewController.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-19.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

class LocationItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    struct Constants {
        static let DefaultCell = "defaultCell"
    }
    
    let tableview = UITableView.init(frame: .zero, style: .plain)
        
    init() {
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
        
    }
    
    // MARK: Tableview Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.DefaultCell, for: indexPath) as! ItemTableViewCell
        
//        cell.delegate = self
//        cell.setLocation(location: cityLocations[indexPath.row])
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
