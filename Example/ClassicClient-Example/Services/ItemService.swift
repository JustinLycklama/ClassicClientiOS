//
//  ItemService.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-23.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient

struct Item: Codable, Equatable {
    public var id: Int
    public var name: String
    public var count: Int
    public var kgPerUnit: CGFloat
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}


//class ItemService: NSObject, FakeServerProtocol {
//    typealias T = Item
//    let dataFileName = "items"
//}
