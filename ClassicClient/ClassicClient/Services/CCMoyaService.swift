//
//  CCMoyaService.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-08-29.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import Moya
import Alamofire

import ObjectMapper
import Moya_ObjectMapper

public protocol CCRequest {
    associatedtype ServiceEnvelope: EnvelopeType = Envelope<ServiceResponse>
    associatedtype ServiceResponse: Mappable
    associatedtype ServiceTarget: CCTarget
    
    func getTarget() -> ServiceTarget
}

public protocol CCTarget: TargetType {}

public extension CCRequest {
    func request(_ completion: @escaping (Result<ServiceResponse>) -> Void) {
            
        let target = getTarget()
        let provider = MoyaProvider<ServiceTarget>(plugins: [NetworkLoggerPlugin()])
        
        provider.request(target) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let statusCode = moyaResponse.statusCode
                // do something with the response data or statusCode
                
                
                    if let returnString = String.init(data: data, encoding: .utf8) {
                        print("-----\n", self, #line, " ", #file, " ", returnString)
                    }
                
                do {
//                    let repos: [Plant] = try moyaResponse.mapArray(Plant.self)

                    
                    let envelope = try moyaResponse.mapObject(ServiceEnvelope.self)
                                                                                    
                    completion(Result.success(envelope.responseList as? [ServiceResponse] ?? []))
                    
                } catch {
                    completion(Result.error(NSError(domain: "Could not deserialize", code: 1, userInfo: nil)))
                }
            case let .failure(error):
                break
                completion(Result.error(NSError(domain: "Request failed", code: 1, userInfo: nil)))
            }
        }
    }
}

/*
 * Envelope
 */

public protocol EnvelopeType : Mappable {
    associatedtype T: Mappable
    
    var responseList: [T]? { get }
}

public struct Envelope<T: Mappable>: EnvelopeType {
    public var responseList: [T]?
    
    public init?(map: Map) { }
    
    public mutating func mapping(map: Map) {
        // For now, force the selection of the first element. Won't be like that in the future.
        responseList <- map["data"]
    }
}

/*
 * Mapping Structures
 */

public struct GenericIdentifier<T>: RawRepresentable, Hashable, Equatable {
    public let rawValue: Int
    public var hashValue: Int { get { return rawValue } }
    
    public init(rawValue: Int) { self.rawValue = rawValue }
}

public extension GenericIdentifier where T: IdentifiableMappable {
    static var transform: TransformOf<GenericIdentifier<T>, Int> {
        get {
            return TransformOf<GenericIdentifier<T>, Int>(fromJSON: { (primaryKey: Int?) -> GenericIdentifier<T>? in
                if let primaryKey = primaryKey {
                    return GenericIdentifier<T>(rawValue: primaryKey)
                }
                return nil
            }, toJSON: { (genericIdentifier: GenericIdentifier<T>?) -> Int? in
                if let genericIdentifier = genericIdentifier {
                    return genericIdentifier.rawValue
                }
                
                return nil
            })
        }
    }
}

public protocol IdentifiableMappable: Mappable, Hashable {
    typealias Id = GenericIdentifier<Self>

    var id: Id! { get }
}

public extension Mappable where Self: IdentifiableMappable {
    public var hashValue: Int { get { return id.rawValue.hashValue } }
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id.rawValue == rhs.id.rawValue
    }
}
