//
//  Requester.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-16.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import Foundation

class Requester<T: Codable> {

    let logger: AppLogger = .shared
    
    let params: RequestParams
        
    var mapSuccess: ((T) -> Swift.Result<T, ServiceError>) = { value in .success(value) }
    
    init(_ params: RequestParams) {
        self.params = params
    }
    
    @discardableResult
    /// Performs request and returns to the main thread
    func doRequest(completion: @escaping (Swift.Result<T, ServiceError>) -> Void) -> Cancellable? {
        let request = NetworkRequest<T>(params: params)
        return request.performRequest() { result, data in
                    
            // For now lets move back to the main thread here for safety. In the future we can reconsider optimizing this
            DispatchQueue.main.async {
                let _ = data
                
                let mappedResult = result.flatMap { value in
                    self.mapSuccess(value)
                }
                
                completion(mappedResult)
            }
        }
    }
}

extension Requester {
    func mapped<R: Codable>(_ mapping: @escaping (T) -> Result<R, ServiceError>) -> MappedRequester<R, T> {
        return MappedRequester<R, T>(self, mapping: mapping)
    }
}

class MappedRequester<T: Codable, RequestType: Codable> {
    
    private let requester: Requester<RequestType>
    private let map: ((RequestType) -> Result<T, ServiceError>)
    
    var params: RequestParams { requester.params }
    
    init(_ requester: Requester<RequestType>, mapping: @escaping (RequestType) -> Result<T, ServiceError>) {
        self.requester = requester
        self.map = mapping
    }
    
    @discardableResult
    func doRequest(completion: @escaping (Swift.Result<T, ServiceError>) -> Void) -> Cancellable? {
        return requester.doRequest { result in
            completion(result.flatMap(self.map))
        }
    }
}




//protocol Requestable {
//    associatedtype Value: Codable
//
//    var params: RequestParams { get }
//    
//    @discardableResult
//    func doRequest(completion: @escaping (Result<Value, ServiceError>) -> Void) -> Cancellable?
//    
//    // Mappings
//    func mapSuccess(_: Value) -> Result<Value, ServiceError>
//}
//
//extension Requestable {
//    // Mapping
//    func mapSuccess(_ value: Value) -> Result<Value, ServiceError> { .success(value) }
//}
