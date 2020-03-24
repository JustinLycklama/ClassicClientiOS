//
//  LocationsViewControler.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-23.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import MapKit

class LocationsViewControler: UIViewController, UITableViewDelegate, UITableViewDataSource, LocationMapSelectionDelegate {
    struct Constants {
        static let DefaultCell = "defaultCell"
    }
    
    let tableview = UITableView.init(frame: .zero, style: .grouped)
    let cityLocations: [Location]
    
    
    init(cityName: String) {
        cityLocations = LocationViewModel.sharedInstance.getCachedLocations(fromCity: cityName)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Addresses"
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "CityLocationTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.DefaultCell)
                    
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(tableview)
        self.view.constrainSubviewToBounds(tableview)
        
        tableview.reloadData()
        
    }
    
    // MARK: Tableview Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.DefaultCell, for: indexPath) as! CityLocationTableViewCell
        
        cell.delegate = self
        cell.setLocation(location: cityLocations[indexPath.row])
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemsVC = LocationItemsViewController(forLocation: cityLocations[indexPath.row])
        
        navigationController?.pushViewController(itemsVC, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: LocationMapSelectionDelegate
    func presentMapForLocation(location: Location) {
        
//        UIApplication.shared.openURL(URL(string:"https://www.google.com/maps/@42.585444,13.007813,6z")!)
        let coordinate = CLLocationCoordinate2DMake(42.585444,13.007813)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "Target location"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        
//        //Working in Swift new versions.
//        if
//            let url = URL(string: "https://www.google.com/maps/search/?api=1")
//        {
//            //UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)
//            UIApplication.shared.open(url)
//        } else
//        {
//            NSLog("Can't use com.google.maps://");
//        }
    }
}
