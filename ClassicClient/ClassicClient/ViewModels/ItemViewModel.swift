//
//  ItemViewModel.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-23.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

class ItemViewModel {
    
    public static let sharedInstance = ItemViewModel()
    
    private let itemService: ItemService
    
    init() {
        itemService = ItemService()
    }
    
    public func getItems(forLocationId locationId: Int, callback: ((Result<Item>) -> Void)?) {
        itemService.request { (result: Result<Item>) in
            callback?(result)
        }
    }
}
