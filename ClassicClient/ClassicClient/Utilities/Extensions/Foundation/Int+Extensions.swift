//
//  Int+Extensions.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-15.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import Foundation

// MARK: String to Int

@propertyWrapper
struct StringyInt<Value: ExpressibleByInt & Codable>: Codable {
    var wrappedValue: Value?
}

extension StringyInt {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringifiedValue = try? container.decode(String.self), let int = Int(stringifiedValue) {
            wrappedValue = .init(int)
        } else {
            wrappedValue = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let wrappedValue {
            try container.encode(String(wrappedValue.int))
        }
    }
}

// MARK: Double to Int
@propertyWrapper
struct DoublyInt<Value: ExpressibleByInt & Codable>: Codable {
    var wrappedValue: Value?
}

extension DoublyInt {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let doubleValue = try? container.decode(Double.self) {
            wrappedValue = .init(Int(doubleValue))
        } else {
            wrappedValue = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let wrappedValue {
            try container.encode(Double(wrappedValue.int))
        }
    }
}

// MARK: Configuring @propertyWrapper to work with codingKeys
protocol ExpressibleByInt {
    init(_ val: Int)
    var int: Int { get }
}

extension Int: ExpressibleByInt {
    init(_ int: Int) {
        self = int
    }
    var int: Int { self }
}

//extension Optional: ExpressibleByInt where Wrapped == Int {
//    init(_ int: Int) {
//        self = int
//    }
//    var int: Int { self ?? -1 }
//}

extension KeyedDecodingContainer {
    func decode<T: ExpressibleByNilLiteral>(_ type: StringyInt<T>.Type, forKey key: K) throws -> StringyInt<T> {
        if let value = try self.decodeIfPresent(type, forKey: key) {
            return value
        }
                
        return StringyInt(wrappedValue: nil)
    }
    
    func decode<T: ExpressibleByNilLiteral>(_ type: DoublyInt<T>.Type, forKey key: K) throws -> DoublyInt<T> {
        if let value = try self.decodeIfPresent(type, forKey: key) {
            return value
        }
                
        return DoublyInt(wrappedValue: nil)
    }
}
