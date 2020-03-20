//
//  LocationViewController.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-19.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    struct Constants {
        static let DefaultCell = "defaultCell"
    }
        
    let tableview = UITableView()
    let loadingView = LoadingView()
    
    var citiesList: [String]?
    
    // MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        
        LocationViewModel.sharedInstance.getCityList { [weak self] (result: Result<String>) in
            switch result {
            case .success(let results):
                self?.citiesList = results
                self?.tableview.reloadData()
                break
            case .error(let error):
                
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: Constants.DefaultCell)
        
        tableview.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(tableview)
        self.view.addSubview(loadingView)
        
        self.view.constrainSubviewToBounds(tableview)
        
        tableview.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: Tableview Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.DefaultCell, for: indexPath)
        
        cell.textLabel?.text = citiesList?[indexPath.row] ?? ""
        
        return cell
    }
    
}
