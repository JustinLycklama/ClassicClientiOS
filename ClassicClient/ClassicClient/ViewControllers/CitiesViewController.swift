//
//  LocationViewController.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-19.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

class CitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LoginUpdateDelegate {

    struct Constants {
        static let DefaultCell = "defaultCell"
    }
        
    let tableview = UITableView.init(frame: .zero, style: .grouped)
    let loadingView = LoadingView()
    
    var citiesList: [String]?
    
    // MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cities"
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: Constants.DefaultCell)
        
        tableview.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(tableview)
        self.view.addSubview(loadingView)
        
        self.view.constrainSubviewToBounds(tableview)
        
        tableview.reloadData()
        
        LoginViewModel.sharedInstance.subscribeToUpdates(delegate: self)
        
        let barButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logout))
        navigationItem.setLeftBarButton(barButton, animated: false)
    }

    deinit {
        LoginViewModel.sharedInstance.unsubscribeFromUpdates(delegate: self)
    }
    
    // MARK: LoginUpdateDelegate
    func LoginStateUpdated(loggedIn: Bool) {
        guard loggedIn else {
            return
        }
        
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
    
    @objc func logout() {
        LoginViewModel.sharedInstance.logout()
    }
    
    // MARK: Tableview Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.DefaultCell, for: indexPath)
        
        cell.textLabel?.text = citiesList?[indexPath.row] ?? ""
        cell.textLabel?.font = CCStyle.fontWithSize(size: 18)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityLocationsViewController = LocationsViewControler(cityName: citiesList?[indexPath.row] ?? "")
        navigationController?.pushViewController(cityLocationsViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
