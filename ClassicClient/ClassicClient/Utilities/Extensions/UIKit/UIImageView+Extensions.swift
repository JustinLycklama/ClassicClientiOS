//
//  UIImageView+Extensions.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-16.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import UIKit

extension UIImageView {
        
    func setImageViaURL(_ urlString: String?, onComplete: ((UIImage?) -> Void)? = nil) {
        guard let urlString = urlString else {
            return
        }
                
        ImageCache.shared.applyImage(URL(string: urlString), to: self, onComplete: onComplete)
    }
}

class ImageCache {
    
    static let shared = ImageCache()
    typealias Completion = ((UIImage?) -> Void)?
    
    var cacheMap = [URL: UIImage]()
    
    var currentRequests = Set<URL>()
    var requestImageViewMap = [UIImageView : (URL, Completion)]()
    
    init() {
    }
    
    func clear() {
        cacheMap.removeAll()
        requestImageViewMap.removeAll()
        // We cannot cancel here, so do not remove current requests.
    }
    
    func applyImage(_ imageUrl: URL?, 
                    to imageView: UIImageView,
                    defaultImage: UIImage? = nil,
                    onComplete: Completion = nil) {
                
        // 'Cancel' any previous request with from this imageView.
        // That request will still finish to fetch the image and cache it.
        requestImageViewMap.removeValue(forKey: imageView)
        
        imageView.image = defaultImage
        
        guard let imageUrl else {
            onComplete?(nil)
            return
        }
        
        if let image = cacheMap[imageUrl] {
            imageView.image = image
            onComplete?(image)

            return
        }
        
        // We have a url and need to wait for a request to finish, add to our list
        requestImageViewMap[imageView] = (imageUrl, onComplete)
        
        if currentRequests.contains(imageUrl) {
            // Wait for it to finish elsewhere
            // Do not complete
            return
        }
        
        currentRequests.insert(imageUrl)
        
        downloadImage(from: imageUrl) { [weak self] image in
            guard let self else { return }
            
            self.cacheMap[imageUrl] = image
            self.currentRequests.remove(imageUrl)
            
            for imageView in self.requestImageViewMap.keys {
                if self.requestImageViewMap[imageView]?.0 == imageUrl {
                    imageView.image = image
                    // Call our completion to let the caller know the image has been asssigned
                    self.requestImageViewMap[imageView]?.1?(image)
                    self.requestImageViewMap.removeValue(forKey: imageView)
                }
            }
        }
    }
    
    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }

        // If we need cancellation later on
//        let task = URLSession
//            .shared
//            .dataTask(with: url, completionHandler: { data, response, error in
//                guard let data = data, error == nil else {
//                    DispatchQueue.main.async() {
//                        completion(nil)
//                    }
//                    return
//                }
//
//                let image = UIImage(data: data)
//                DispatchQueue.main.async() {
//                    completion(image)
//                }
//            })
//
//        task.resume()
    }
}
