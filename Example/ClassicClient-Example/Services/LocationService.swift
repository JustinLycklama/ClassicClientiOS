//
//  LocationService.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-20.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient

struct Location: Codable {
    public var id: Int
    public var locationName: String
    public var cityName: String
    public var address: String
}

//class LocationService: NSObject, FakeServerProtocol {
//    typealias T = Location
//    let dataFileName = "locations"
//}
