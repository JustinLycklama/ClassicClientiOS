//
//  ItemService.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-23.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient

class ItemService: NSObject, FakeServerProtocol {
    typealias T = Item
    let dataFileName = "items"
}
