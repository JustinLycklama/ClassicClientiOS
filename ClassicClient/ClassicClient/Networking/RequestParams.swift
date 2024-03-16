//
//  RequestParams.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-16.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import Foundation

struct FormData {
    let fieldName: String
    let fileName: String
    let mimeType: String
    let fileData: Data
}

class RequestParams {

    let baseURL: URL
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    let path: String

    /// The HTTP method used in the request.
    let method: HTTPMethod

    /// The headers to be used in the request.
    let headers: [String: String]?

    /// The query params to be used in the request.
    private let paramsClosure: (() -> [String : String]?)?
    var params: [String: String]? { paramsClosure?() }

    /// The body to be used in the request.
    private let bodyClosure: (() -> [String : Encodable]?)?
    var body: [String : Encodable]? {
        bodyClosure?()
    }
    
    /// The body to be used in the request.
    private let multipartBodyClosure: (() -> [FormData]?)?
    var multipartBody: [FormData]? {
        multipartBodyClosure?()
    }
    
    var clearsCookies: Bool = false
    
    let sampleFile: String?
        
    // Will probably run in to some issues trying to cache using SimpleService
    var shouldCache: Bool { false }
    
    init(baseUrl: URL,
         path: String,
         method: HTTPMethod = .get,
         headers: [String: String]? = nil,
         paramsClosure: (() -> [String : String]?)? = nil,
         bodyClosure: (() -> [String : Encodable]?)? = nil,
         multipartBodyClosure: (() -> [FormData]?)? = nil,
         sampleFile: String? = nil) {
        self.baseURL = baseUrl
        self.path = path
        self.method = method
        self.headers = headers
        self.paramsClosure = paramsClosure
        self.bodyClosure = bodyClosure
        self.multipartBodyClosure = multipartBodyClosure
        self.sampleFile = sampleFile
    }
}

extension RequestParams: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(path)
        hasher.combine(headers)
        hasher.combine(params)
        
        let data: Data?
        if #available(iOS 11.0, *) {
            data = try? JSONSerialization.data(withJSONObject: body ?? [:], options: [.prettyPrinted, .sortedKeys])
        } else {
            data = try? JSONSerialization.data(withJSONObject: body ?? [:], options: [.prettyPrinted])
        }
        
        hasher.combine(data)
    }
    
    static func == (lhs: RequestParams, rhs: RequestParams) -> Bool {
        
        let lhsData: Data?
        let rhsData: Data?
        
        if #available(iOS 11.0, *) {
            lhsData = try? JSONSerialization.data(withJSONObject: lhs.body ?? [:], options: [.prettyPrinted, .sortedKeys])
        } else {
            lhsData = try? JSONSerialization.data(withJSONObject: lhs.body ?? [:], options: [.prettyPrinted])
        }
        
        if #available(iOS 11.0, *) {
            rhsData = try? JSONSerialization.data(withJSONObject: rhs.body ?? [:], options: [.prettyPrinted, .sortedKeys])
        } else {
            rhsData = try? JSONSerialization.data(withJSONObject: rhs.body ?? [:], options: [.prettyPrinted])
        }
        
        return lhs.path == rhs.path &&
        lhs.headers == rhs.headers &&
        lhs.params == rhs.params &&
        lhsData == rhsData
    }
}
