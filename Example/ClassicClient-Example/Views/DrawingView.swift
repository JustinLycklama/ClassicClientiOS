//
//  DrawingView.swift
//  ClassicClient
//
//  Taken from https://www.raywenderlich.com/5895-uikit-drawing-tutorial-how-to-make-a-simple-drawing-app
//

//import UIKit
//
//public class DrawingView: UIView {
//
//    let mainImageView = UIImageView()
//    let tempImageView = UIImageView()
//    
//    
//    var lastPoint = CGPoint.zero
//    var color = UIColor.black
//    var brushWidth: CGFloat = 10.0
//    var opacity: CGFloat = 1.0
//    var swiped = false
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        for view in [mainImageView, tempImageView] {
//            addSubview(view)
//            constrainSubviewToBounds(view)
//        }
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    public func clear() {
//        mainImageView.image = nil
//        tempImageView.image = nil
//    }
//    
//    /*
//     Copied from
//     https://www.raywenderlich.com/5895-uikit-drawing-tutorial-how-to-make-a-simple-drawing-app
//     */
//    
//    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//      guard let touch = touches.first else {
//        return
//      }
//      swiped = false
//      lastPoint = touch.location(in: self)
//    }
//    
//    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
//      // 1
//      UIGraphicsBeginImageContext(self.frame.size)
//      guard let context = UIGraphicsGetCurrentContext() else {
//        return
//      }
//      tempImageView.image?.draw(in: self.bounds)
//        
//      // 2
//      context.move(to: fromPoint)
//      context.addLine(to: toPoint)
//      
//      // 3
//      context.setLineCap(.round)
//      context.setBlendMode(.normal)
//      context.setLineWidth(brushWidth)
//      context.setStrokeColor(color.cgColor)
//      
//      // 4
//      context.strokePath()
//      
//      // 5
//      tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
//      tempImageView.alpha = opacity
//      UIGraphicsEndImageContext()
//    }
//
//    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//      guard let touch = touches.first else {
//        return
//      }
//
//      // 6
//      swiped = true
//      let currentPoint = touch.location(in: self)
//      drawLine(from: lastPoint, to: currentPoint)
//        
//      // 7
//      lastPoint = currentPoint
//    }
//    
//    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//      if !swiped {
//        // draw a single point
//        drawLine(from: lastPoint, to: lastPoint)
//      }
//        
//      // Merge tempImageView into mainImageView
//      UIGraphicsBeginImageContext(mainImageView.frame.size)
//      mainImageView.image?.draw(in: self.bounds, blendMode: .normal, alpha: 1.0)
//      tempImageView.image?.draw(in: self.bounds, blendMode: .normal, alpha: opacity)
//      mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
//      UIGraphicsEndImageContext()
//        
//      tempImageView.image = nil
//    }
//}
