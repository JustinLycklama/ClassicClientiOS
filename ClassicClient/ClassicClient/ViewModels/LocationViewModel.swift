//
//  LocationViewModel.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-20.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

class LocationViewModel: NSObject {
    public static let sharedInstance = LocationViewModel()
    
    private let locationService: LocationService
    private var cachedLocationMap: [String : [Location]]?
    
    override init() {
        locationService = LocationService()
    }
    
    public func getCityList(callback: ((Result<String>) -> Void)?) {
        locationService.request { [weak self] (result: Result<Location>) in
            switch result {
            case .success(let results):
                self?.sortResults(locations: results)
                
                let cities: [String] = self?.cachedLocationMap?.keys.sorted() ?? []
                callback?(.success(cities))
                break
            case .error(let error):
                callback?(.error(error))
                break
            }
        }
    }
    
    public func getCachedLocations(fromCity city: String) -> [Location] {
        return cachedLocationMap?[city] ?? []
    }
    
    private func sortResults(locations: [Location]) {
        
        var map = [String : [Location]]()
        
        for location in locations {
            let cityName = location.cityName
            
            if (map[cityName] == nil) {
                map[cityName] = [Location]()
            }
            
            map[cityName]?.append(location)
        }
    
        cachedLocationMap = map
    }
}
