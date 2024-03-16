//
//  TriangleView.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-15.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import UIKit

class TriangleView : UIView {

    enum Direction {
        case up
        case down
        case topRight
        case topLeft
    }
    
    var direction: Direction = .down
    
    private var color: UIColor = .white
    override var backgroundColor: UIColor? {
        set {
            color = newValue ?? .white
        }
        get {
            color
        }
    }
    
    private var gradient: CGGradient?
    func setColorGradient(left: UIColor, right: UIColor) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
              
          guard let startColorComponents = left.cgColor.components else { return }
          guard let endColorComponents = right.cgColor.components else { return }
            
          let colorComponents: [CGFloat]
                  = [startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]]
              
          let locations:[CGFloat] = [0.0, 1.0]
          gradient = CGGradient(colorSpace: colorSpace,
                                colorComponents: colorComponents,
                                locations: locations,
                                count: 2)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        super.backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.beginPath()
        switch direction {
        case .up:
            context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        case .down:
            context.move(to: CGPoint(x: rect.minX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.maxY))
        case .topRight:
            context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        case .topLeft:
            context.move(to: CGPoint(x: rect.minX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        }

        context.closePath()
        
        if let gradient = gradient {
            if let path = context.path {
                let bezPath = UIBezierPath(cgPath: path)
                bezPath.addClip()
            }
            
            let startPoint = CGPoint(x: 0, y: self.bounds.height)
            let endPoint = CGPoint(x: self.bounds.width,y: self.bounds.height)
                
            context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        } else {
            context.setFillColor(color.cgColor)
        }
        
        context.fillPath()
    }
}
