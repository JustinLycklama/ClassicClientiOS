//
//  DrawingView.swift
//  ClassicClient
//
//  Taken from https://www.raywenderlich.com/5895-uikit-drawing-tutorial-how-to-make-a-simple-drawing-app
//

import UIKit

class DrawingView: UIView {

    let mainImageView = UIImageView()
    let tempImageView = UIImageView()
    
    
    var lastPoint = CGPoint.zero
    var color = UIColor.black
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for view in [mainImageView, tempImageView] {
            addSubview(view)
            constrainSubviewToBounds(view)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clear() {
        mainImageView.image = nil
        tempImageView.image = nil
    }
    
    /*
     Copied from
     https://www.raywenderlich.com/5895-uikit-drawing-tutorial-how-to-make-a-simple-drawing-app
     */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      guard let touch = touches.first else {
        return
      }
      swiped = false
      lastPoint = touch.location(in: self)
    }
    
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
      // 1
      UIGraphicsBeginImageContext(self.frame.size)
      guard let context = UIGraphicsGetCurrentContext() else {
        return
      }
      tempImageView.image?.draw(in: self.bounds)
        
      // 2
      context.move(to: fromPoint)
      context.addLine(to: toPoint)
      
      // 3
      context.setLineCap(.round)
      context.setBlendMode(.normal)
      context.setLineWidth(brushWidth)
      context.setStrokeColor(color.cgColor)
      
      // 4
      context.strokePath()
      
      // 5
      tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
      tempImageView.alpha = opacity
      UIGraphicsEndImageContext()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      guard let touch = touches.first else {
        return
      }

      // 6
      swiped = true
      let currentPoint = touch.location(in: self)
      drawLine(from: lastPoint, to: currentPoint)
        
      // 7
      lastPoint = currentPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      if !swiped {
        // draw a single point
        drawLine(from: lastPoint, to: lastPoint)
      }
        
      // Merge tempImageView into mainImageView
      UIGraphicsBeginImageContext(mainImageView.frame.size)
      mainImageView.image?.draw(in: self.bounds, blendMode: .normal, alpha: 1.0)
      tempImageView.image?.draw(in: self.bounds, blendMode: .normal, alpha: opacity)
      mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
        
      tempImageView.image = nil
    }
    
    
    
    
    
    
    
    /*var drawColor = UIColor.black    // A color for drawing
    var lineWidth: CGFloat = 5        // A line width
        
    private var lastPoint: CGPoint!        // A point for storing the last position
    private var bezierPath: UIBezierPath!    // A bezier path
    private var pointCounter: Int = 0    // A counter of ponts
    private let pointLimit: Int = 128    // A limit of points
    private var preRenderImage: UIImage!    // A pre-render image

    override init(frame: CGRect) {
        super.init(frame: frame)
            
        initBezierPath()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initBezierPath()
    }
        
    func initBezierPath() {
        bezierPath = UIBezierPath()
        bezierPath.lineCapStyle = .round
        bezierPath.lineJoinStyle = .round
    }
    
    func renderToImage() {
            
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        if preRenderImage != nil {
            preRenderImage.draw(in: self.bounds)
        }
            
        bezierPath.lineWidth = lineWidth
        drawColor.setFill()
        drawColor.setStroke()
        bezierPath.stroke()
            
        preRenderImage = UIGraphicsGetImageFromCurrentImageContext()
            
        UIGraphicsEndImageContext()
    }
    
    func clear() {
        preRenderImage = nil
        bezierPath.removeAllPoints()
        setNeedsDisplay()
    }

    func hasLines() -> Bool {
        return preRenderImage != nil || !bezierPath.isEmpty
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
            
        if preRenderImage != nil {
            preRenderImage.draw(in: self.bounds)
        }
            
        bezierPath.lineWidth = lineWidth
        drawColor.setFill()
        drawColor.setStroke()
        bezierPath.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        lastPoint = touch.location(in: self)
        pointCounter = 0
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let newPoint = touch.location(in: self)
            
        bezierPath.move(to: lastPoint)
        bezierPath.addLine(to: newPoint)
        lastPoint = newPoint
            
        pointCounter += 1
            
        if pointCounter == pointLimit {
            pointCounter = 0
            renderToImage()
            setNeedsDisplay()
            bezierPath.removeAllPoints()
        }
        else {
            setNeedsDisplay()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }*/
}
