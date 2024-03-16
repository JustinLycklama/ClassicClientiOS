//
//  NetworkRequest.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-16.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import CoreText
import Foundation

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

public protocol Cancellable {
    func cancel()
}

public extension Cancellable {
    func store(inList list: inout [Cancellable]) {
        list.append(self)
    }
}

extension URLSessionDataTask: Cancellable {}

public struct Exception: Codable {
    let exception: String
    let exc: String?
}

public enum ServiceError: Error {
    case couldNotParseURL
    case failedInTransport(_ error: Error)
    case failedWithMessage(_ message: String)
    case unableToDecodeResponse
    case couldNotMapResponse
    
    // Example: If the http request was a success, but the object itself has a message "Request Failed"
    case returnedObjectDenotesFailure
}


public struct ResponseWrapper<T: Codable>: Codable {
    let message: T
}

// Empty
public struct EmptyResponse: Codable {}

public struct OptionalCodable<T>: Codable where T: Codable {
    
    let value: T?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let object = try? container.decode(T.self) {
            self.value = .some(object)
        } else if let _ = try? container.decode(EmptyResponse.self) {
            self.value = .none
        } else {
            throw ServiceError.unableToDecodeResponse
        }
    }
}

public class NetworkRequest<T: Codable> {

    private let params: RequestParams
    private let logger: AppLogger
    
    init(params: RequestParams, logger: AppLogger = AppLogger.shared) {
        self.params = params
        self.logger = logger
    }
    
    // MARK: Public
    
    /// Performs a request for a service. Returns in a background thread
    func performRequest(completion: @escaping ((Result<T, ServiceError>, Data?) -> Void)) -> Cancellable? {
                        
        guard let request = buildRequest() else {
            completion(.failure(ServiceError.couldNotParseURL), nil)
            return nil
        }
        
        logger.log("Request Sent:", request)
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                self.logger.log("Request Failed: \(error.localizedDescription)\n\(request.fullDescription)", severity: .error)
                
                if (error as NSError).code == NSURLErrorCancelled {
                    // This request has been cancelled from our end, lets not propogate it down to the UI
                    // Otherwise we would have to handle each case of the request being cancelled
                    return
                }
                
                // Error is transport error
                completion(.failure(.failedInTransport(error)), data)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                self.logger.log("Response is not HTTPURLResponse", severity: .error)
                completion(.failure(.unableToDecodeResponse), data)
                return
            }
            
            // Status code can be any successful response
            if 200..<300 ~= httpResponse.statusCode {
                self.logger.log("Request Successful\n\(request.fullDescription)")
                
                if let response: T = self.decodeData(data) {
                    completion(.success(response), data)
                    return
                }
                
                // We could not parse a successful object.
                self.logger.log("Failed to Decode Response\n\(request.fullDescription)", severity: .error)
                self.logger.log(data?.prettyPrintedJSONString, severity: .error)
                
                self.logParseErrors(data)
                
                completion(.failure(.unableToDecodeResponse), data)
            } else {
                self.logger.log("Request Failed Status Code \(httpResponse.statusCode)\n\(request.fullDescription)", severity: .error)
                
                if let failureMessage: String = self.decodeData(data) {
                    self.logger.log(failureMessage, severity: .error)
                    completion(.failure(.failedWithMessage(failureMessage)), data)
                    return
                }
                
                self.logger.log("Failed to Decode Response", severity: .error)
                self.logger.log(data?.prettyPrintedJSONString, severity: .error)
                
                completion(.failure(.unableToDecodeResponse), data)
            }
        }
        
        dataTask.resume()
        return dataTask
    }
    
    // MARK: Private
    
    private func buildRequest() -> URLRequest? {
        var urlBuilder = URLComponents(url: params.baseURL, resolvingAgainstBaseURL: false)
        urlBuilder?.path += params.path
        
        // Add Query Params
        urlBuilder?.queryItems = params.params?.compactMap({ (key: String, value: String) in
            URLQueryItem(name: key, value: value)
        })
                
        guard let url = urlBuilder?.url else {
            return nil
        }
                
        var request: URLRequest?
        if params.multipartBody != nil {
            request = buildContentMultipartRequest(url)
        } else {
            request = buildContentApplicationJsonRequest(url)
        }
        
        request?.httpMethod = params.method.rawValue
        
        return request
    }
    
    // MARK: - Standard request - Application/JSON
    private func buildContentApplicationJsonRequest(_ url: URL) -> URLRequest? {
        var request = URLRequest(url: url)
        
        // Content Type Header
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        // Custom Headers
        for key in (params.headers ?? [:]).keys {
            if let value = params.headers?[key] {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let bodyJson = params.body {
            
            // JSONSerialization only accepts native types like String, Int, Dict, ...
            // To also accept our Identifier<Type> structs we use NativeJsonEncodable protocol
            
            let mappedBody = bodyJson.mapValues { jsonValue -> Encodable in
                if let nativeEncodable = jsonValue as? NativeJsonEncodable {
                    return nativeEncodable.nativeJsonValue
                } else {
                    return jsonValue
                }
            }
            
            guard JSONSerialization.isValidJSONObject(mappedBody) else {
                logger.log("INVALID JSON OBJECT. \(mappedBody).")
                return nil
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: mappedBody)
                request.httpBody = jsonData
            } catch  {
                logger.log("Could not encode json body. \(params).")
            }
        }
        
        return request
    }
    
    // MARK: - Multipart Data
    private func buildContentMultipartRequest(_ url: URL) -> URLRequest? {
        var request = URLRequest(url: url)
        
        let boundary = "Boundary-\(UUID().uuidString)"

        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let httpBody = NSMutableData()

        for (key, value) in params.headers ?? [:] {
          httpBody.appendString(convertFormField(named: key, value: value, using: boundary))
        }

        for formData in params.multipartBody ?? [] {
            httpBody.append(convertFileData(fieldName: formData.fieldName,
                                            fileName: formData.fileName,
                                            mimeType: formData.mimeType,
                                            fileData: formData.fileData,
                                            using: boundary))
        }

        httpBody.appendString("--\(boundary)--")

        request.httpBody = httpBody as Data
        
        return request
    }
    
    private func convertFormField(named name: String, value: String, using boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "Content-Type: \("text/plain")\r\n"
        fieldString += "\r\n"
        fieldString += value
        fieldString += "\r\n"
        
        return fieldString
    }
    
    private func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        let data = NSMutableData()
        
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        
        return data as Data
    }
    
    // MARK: - Decode and parse
    
    private func decodeData<C: Codable>(_ data: Data?) -> C? {
        guard let data = data else {
            return nil
        }

        if let wrapperObject = try? JSONDecoder().decode(ResponseWrapper<C>.self, from: data) {
            return wrapperObject.message
        }
        
        if let object = try? JSONDecoder().decode(C.self, from: data) {
            logger.log("No Wrapper recieved in response in request \(params.path)", severity: .error)
            return object
        }

        return nil
    }
    
    private func logParseError<C: Codable>(_ data: Data?) -> C? {
        guard let data = data else {
            return nil
        }
        
        do {
            let _ = try JSONDecoder().decode(C.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            logger.log("could not find key \(key) in JSON: \(context.codingPath)")
        } catch DecodingError.valueNotFound(let type, let context) {
            logger.log("could not find type \(type) in JSON: \(context.codingPath)")
        } catch DecodingError.typeMismatch(let type, let context) {
            logger.log("type mismatch for type \(type) in JSON: \(context.codingPath)")
        } catch DecodingError.dataCorrupted(let context) {
            logger.log("data found to be corrupted in JSON: \(context.codingPath)")
        } catch let error as NSError {
            logger.log("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
        }
        
        return nil
    }
    
    private func logParseErrors(_ data: Data?) {
        let _: ResponseWrapper<T>? = logParseError(data)
    }
}


extension Data {
    var prettyPrintedJSONString: String? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return String(prettyPrintedString)
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}

extension URLRequest {
    var fullDescription: String {
        var text = description
        
        if let headers = allHTTPHeaderFields {
            text.append("\n\(headers)")
        }
        
        if let body = httpBody?.prettyPrintedJSONString {
            text.append("\n\(body)")
        }
         
        return text
    }
}

func showCookies() {
    for cookie in HTTPCookieStorage.shared.cookies ?? [] {
        debugPrint("\(cookie.name): \(cookie.value)")
    }
}

func clearCookies() {
    let cookieStore = HTTPCookieStorage.shared
    
    for cookie in cookieStore.cookies ?? [] {
        cookieStore.deleteCookie(cookie)
    }
}
