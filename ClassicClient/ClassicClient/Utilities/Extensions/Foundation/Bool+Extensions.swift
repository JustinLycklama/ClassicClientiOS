//
//  Bool+Extensions.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-15.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import Foundation

@propertyWrapper
struct IntyBool<Value: ExpressibleByBool & Codable>: Codable {
    var wrappedValue: Value
}

extension IntyBool {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intifiedValue = try? container.decode(Int.self) {
            wrappedValue = .init(intifiedValue == 1)
        } else {
            wrappedValue = .init(false)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue.bool ? 1 : 0)
    }
}

// MARK: Configuring @propertyWrapper to work with codingKeys
protocol ExpressibleByBool {
    init(_ bool: Bool)
    var bool: Bool { get }
}

extension Bool: ExpressibleByBool {
    init(_ bool: Bool) {
        self = bool
    }
    var bool: Bool { self }
}

extension Optional: ExpressibleByBool where Wrapped == Bool {
    init(_ bool: Bool) {
        self = bool
    }
    var bool: Bool { self ?? false }
}

extension KeyedDecodingContainer {
    func decode<T: ExpressibleByNilLiteral>(_ type: IntyBool<T>.Type, forKey key: K) throws -> IntyBool<T> {
        if let value = try self.decodeIfPresent(type, forKey: key) {
            return value
        }
                
        return IntyBool(wrappedValue: nil)
    }
}
