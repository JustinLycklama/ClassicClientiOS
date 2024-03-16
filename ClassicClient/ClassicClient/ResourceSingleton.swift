//
//  ResourceSingleton.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-08-29.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import Foundation

public class ResourceSingleton {
    public static let sharedInstance = ResourceSingleton()
    
    public typealias GetImageCompletion = (String, UIImage?) -> Void
    
    struct Requester: Hashable {
        let ref: NSObject
        let completion: GetImageCompletion
        
        var hashValue: Int { return ref.hash }
        func hash(into hasher: inout Hasher) {
            hasher.combine(hashValue)
        }
        
        static func == (lhs: ResourceSingleton.Requester, rhs: ResourceSingleton.Requester) -> Bool {
            return lhs.ref == rhs.ref
        }
    }
    
    private var urlRequestMap = [URL : Set<Requester>]()
    private var registrationMap = [NSObject : URL]()
    private var imageMap = [URL : UIImage]()
    
    
    public func getCachedImage(forUrl urlString: String, by ref: NSObject, completion: @escaping GetImageCompletion) {
        guard let url = URL(string: urlString) else {
            completion(urlString, nil)
            return
        }
        
        unRegisterForImageRequest(requester: ref)
        
        if let cachedImage = imageMap[url] {
            completion(urlString, cachedImage)
            return
        }
        
        let requester = Requester(ref: ref, completion: completion)
        let currentRequestExists = urlRequestMap.keys.contains(url)
        
        if !currentRequestExists {
            urlRequestMap[url] = Set<Requester>()
        }
        
        urlRequestMap[url]!.insert(requester)
        registrationMap[ref] = url

        if (!currentRequestExists) {
            URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
                var image: UIImage? = nil
                
                print("--")
                for key: URL in (self?.urlRequestMap ?? [:]).keys {
                    print(key)
                }
                print("---")
                
                if let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil {
                    
                    image = UIImage(data: data)
                    
                    self?.imageMap[url] = image
                }
                
                DispatchQueue.main.async() { [weak self] in
                    for requester in self?.urlRequestMap[url] ?? [] {
                        requester.completion(urlString, image)
                        
                        self?.registrationMap[requester.ref] = nil
                    }
                    
                    self?.urlRequestMap[url]?.removeAll()
                    self?.urlRequestMap[url] = nil
                }
            }).resume()
        }
    }
    
    public func unRegisterForImageRequest(requester: NSObject) {
        guard let requesterURL = registrationMap[requester] else {
            return
        }
        
        urlRequestMap[requesterURL]?.filter({ (rq: Requester) -> Bool in
            return rq.ref != requester
        })
        
        registrationMap[requester] = nil
    }
}
