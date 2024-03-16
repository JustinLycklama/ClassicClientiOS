//
//  Indentifiable.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-15.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import Foundation

// MARK: Identifiable

protocol Identifiable: Hashable {
    associatedtype RawIdentifier: Codable & Equatable = String

    typealias ID = Identifier<Self>
    
    var id: ID { get }
}

extension Identifiable where RawIdentifier: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id.rawValue)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: Identifier

struct Identifier<Value: Identifiable>: Codable, Equatable {
    let rawValue: Value.RawIdentifier

    init(_ rawValue: Value.RawIdentifier) {
        self.rawValue = rawValue
    }
    
    init?(_ rawValue: Value.RawIdentifier?) {
        return nil
    }
}

extension Identifier {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        rawValue = try container.decode(Value.RawIdentifier.self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

extension Identifier: CustomStringConvertible {
    public var description: String {
        return "\(rawValue)"
    }
}

// MARK: NativeJsonEncodable

// JSONSerialization only accepts native types like String, Int, Dict, ...
// To also accept our Identifier<Type> structs we use NativeJsonEncodable protocol'

protocol NativeJsonEncodable {
    var nativeJsonValue: Codable { get }
}

extension Identifier: NativeJsonEncodable {
    var nativeJsonValue: Codable {
        rawValue
    }
}


