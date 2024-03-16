//
//  MockRequester.swift
//  ClassicClient-Example
//
//  Created by Justin Lycklama on 2024-03-16.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ClassicClient

extension DispatchWorkItem: Cancellable {}

class MockRequester<T: Codable>: Requester<T> {
    
    let data: T
    
    init(_ data: T) {
        self.data = data
        
        super.init(RequestParams(baseUrl: URL(string: "")!,
                                 path: "",
                                 method: .get, 
                                 headers: nil,
                                 paramsClosure: nil,
                                 bodyClosure: nil,
                                 multipartBodyClosure: nil,
                                 sampleFile: nil))
    }
    
    @discardableResult
    /// Performs request and returns to the main thread
    override func doRequest(completion: @escaping (Swift.Result<T, ServiceError>) -> Void) -> Cancellable? {
        let maxSeconds: Double = 2
        let minSeconds: Double = 0.2
        
        let randomDelay = Double(arc4random_uniform(UInt32(maxSeconds - minSeconds + 1))) + minSeconds
        let deadline = DispatchTime.now() + randomDelay
        
        let work = DispatchWorkItem {
            completion(.success(self.data))
        }
        
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: work)
        
        return work
    }
}
