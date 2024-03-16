//
//  Enum+Extensions.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-15.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import Foundation

@propertyWrapper
public struct NilOnFail<ValueType>: Codable where ValueType: Codable {

    public var wrappedValue: ValueType?

    public init(wrappedValue: ValueType?) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        self.wrappedValue = try? ValueType(from: decoder)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let value = wrappedValue {
            try container.encode(value)
        } else {
            try container.encodeNil()
        }
    }
}

// MARK: Configuring @propertyWrapper to work with codingKeys
extension KeyedDecodingContainer {
    func decode<T>(_ type: NilOnFail<T>.Type, forKey key: Self.Key) throws -> NilOnFail<T> where T : Decodable {
        return try decodeIfPresent(type, forKey: key) ?? NilOnFail<T>(wrappedValue: nil)
    }
}
