//
//  FakeServerService.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-20.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

enum Result<T> {
    case success(results: [T])
    case error(error: NSError)
}

protocol FakeServerService: NSObject {
    associatedtype T: Decodable
    var dataFileName: String { get }
}

extension FakeServerService {
    func request(callback: ((Result<T>) -> Void)?) {
        fakeFetchData(withFileName: dataFileName, callback: callback)
    }
    
    func fakeFetchData(withFileName filename: String, callback: ((Result<T>) -> Void)?) {
        guard let fileUrl = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("File could not be located at the given url")
            return
        }

        let decoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: fileUrl)
            let results = try decoder.decode([T].self, from: data)

            callback?(.success(results: results))
        } catch {
            callback?(.error(error: NSError.init(domain: "Failed to fetch data", code: 0, userInfo: nil)))
        }
    }
}
