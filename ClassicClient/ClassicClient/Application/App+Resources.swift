//
//  App+Resources.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2021-02-07.
//

import Foundation

public class AppResources {
        
    private var iconMap = [String: UIImage]()
    
    public func getImage(from icon: Icon) -> UIImage? {
        return iconMap[icon.id]
    }
    
    public func register(_ image: UIImage?, for icon: Icon) {
        iconMap[icon.id] = image
    }
    
    public func render(_ image: UIImage?, withColor color: UIColor, andSize size: CGSize) -> UIImage? {
        guard let image = image else {
            return nil
        }
        
        return UIGraphicsImageRenderer(size: CGSize(width: size.width, height: size.height)).image { ctx in
            ctx.cgContext.setFillColor(color.cgColor)
            image.withRenderingMode(.alwaysTemplate).draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
    }
}

public protocol Icon {
    var id: String { get }
    var namespace: String { get }
}

public extension Icon {
    public var namespace: String {
        String(reflecting: type(of: self))
    }
}
