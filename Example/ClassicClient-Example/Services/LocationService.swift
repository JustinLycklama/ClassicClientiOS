//
//  LocationService.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-20.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient

class LocationService: NSObject, FakeServerProtocol {
    typealias T = Location
    let dataFileName = "locations"
}
