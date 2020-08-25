//
//  HorizontalItemTransition.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-08-12.
//

import UIKit

public class HorizontalItemTransition: NSObject, UIViewControllerAnimatedTransitioning { 

    public var fromView: UIView?
    public var viewContainer: UIView?
    public var presenting: Bool = false
    
    /*public func transitionDuration(
          using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
          return 0.20
      }
      
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
          
          if !presenting {
              
              animatePop(using: transitionContext)
              return
          }
          
          let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
          let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
          
          let f = transitionContext.finalFrame(for: tz)
          
          let fOff = f.offsetBy(dx: f.width, dy: 55)
          tz.view.frame = fOff
          
          transitionContext.containerView.insertSubview(tz.view, aboveSubview: fz.view)
          
          UIView.animate(
              withDuration: transitionDuration(using: transitionContext),
              animations: {
                  tz.view.frame = f
          }, completion: {_ in
                  transitionContext.completeTransition(true)
          })
      }
      
      func animatePop(using transitionContext: UIViewControllerContextTransitioning) {
          
          let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
          let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
          
          let f = transitionContext.initialFrame(for: fz)
          let fOffPop = f.offsetBy(dx: f.width, dy: 55)
          
          transitionContext.containerView.insertSubview(tz.view, belowSubview: fz.view)
          
          UIView.animate(
              withDuration: transitionDuration(using: transitionContext),
              animations: {
                  fz.view.frame = fOffPop
          }, completion: {_ in
                  transitionContext.completeTransition(true)
          })
      }*/
    
    private func getContextViews(inContainer containerView: UIView) -> ContextViews {
        
        var maskView: UIView? = nil
        var newCellScreenshotView: UIImageView? = nil
        var originFrame: CGRect?
        
        if let view = fromView,
            let container = viewContainer {
            
            originFrame = container.convert(view.frame, to: containerView)
            
            // Screen shot the cell
            var screenShot: UIImage? = nil
            
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale);
            if let context = UIGraphicsGetCurrentContext() {
                view.layer.render(in: context)
                screenShot = UIGraphicsGetImageFromCurrentImageContext();
            }
            UIGraphicsEndImageContext();
            
            let screenShotView = UIImageView()
            screenShotView.image = screenShot
            
            screenShotView.alpha = 0.75
            containerView.addSubview(screenShotView)
            
            newCellScreenshotView = screenShotView
            
            maskView = UIView()
            maskView?.backgroundColor = .black
            maskView?.alpha = 1
        }
        
        return ContextViews(maskView: maskView, screenshotView: newCellScreenshotView, originFrame: originFrame ?? .zero)
    }
    
    private let completionDuration = 0.35
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                return
        }
        
        let containerView = transitionContext.containerView
        let finalFrameForVC = transitionContext.finalFrame(for: toViewController)
        
        if presenting {
            toViewController.view.frame = finalFrameForVC
            containerView.addSubview(toViewController.view)
            
            let contextViews = getContextViews(inContainer: containerView)
            
            contextViews.screenshotView?.frame = contextViews.originFrame
            contextViews.maskView?.frame = contextViews.originFrame
            
            toViewController.view.mask = contextViews.maskView
            toViewController.view.alpha = 0.15
            
            let totalDuration = transitionDuration(using: transitionContext)
            let clickDuration = 0.20
            let secondaryDuration = totalDuration - clickDuration
            
            let dispatchGroup = DispatchGroup()
            
            transitionContext.containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
            
            if let screenShotView = contextViews.screenshotView {

                // Do the cell 'select' animation
                dispatchGroup.enter()
                UIView.animateKeyframes(withDuration: clickDuration, delay: 0.0, options: .calculationModeCubic, animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                        screenShotView.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1)
                    })
                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                        screenShotView.transform = .identity
                    })
                }) { (completed: Bool) in
                    dispatchGroup.leave()
                }
                
                // Fade the cell out, before reaching the full size
                dispatchGroup.enter()
                UIView.animate(withDuration: secondaryDuration * 0.33,
                               delay: clickDuration * 0.8,
                               options: .curveEaseIn,
                               animations: {
                                
                                screenShotView.alpha = 0
                                
                }) { (finished: Bool) in
                    dispatchGroup.leave()
                    screenShotView.removeFromSuperview()
                }
            }
            
            dispatchGroup.enter()
            UIView.animate(withDuration: secondaryDuration,
                           delay: clickDuration * 0.8,
                           options: .curveEaseIn,
                           animations: {
                            
                            toViewController.view.alpha = 1
                            
                            contextViews.screenshotView?.frame = finalFrameForVC
                            contextViews.maskView?.frame = finalFrameForVC
                            
            }) { (finished: Bool) in
                toViewController.view.mask = nil
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                transitionContext.completeTransition(true)
            }
        } else {
            let contextViews = getContextViews(inContainer: containerView)

            contextViews.maskView?.frame = finalFrameForVC
            contextViews.screenshotView?.frame = finalFrameForVC

            let dispatchGroup = DispatchGroup()

            fromViewController.view.alpha = 1
            fromViewController.view.mask = contextViews.maskView

            let screenshotView = contextViews.screenshotView

            screenshotView?.alpha = 0
            screenshotView?.isOpaque = false

//
//            let f = transitionContext.initialFrame(for: fromViewController)
//            let fOffPop = f.offsetBy(dx: f.width, dy: 55)
            
            transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            
//            UIView.animate(
//                withDuration: transitionDuration(using: transitionContext),
//                animations: {
//                    fromViewController.view.frame = fOffPop
//            }, completion: {_ in
//                    transitionContext.completeTransition(true)
//            })
            
            dispatchGroup.enter()
            UIView.animate(withDuration: completionDuration,
                           delay: 0.0,
                           options: .curveEaseOut,
                           animations: {

                            fromViewController.view.alpha = 0.0

                            contextViews.maskView?.frame = contextViews.originFrame
                            screenshotView?.frame = contextViews.originFrame

            }) { (finished: Bool) in
                fromViewController.view.mask = nil
                dispatchGroup.leave()
            }

            dispatchGroup.enter()
            UIView.animate(withDuration: completionDuration * 0.3,
                           delay: completionDuration * 0.7,
                           options: .curveEaseOut,
                           animations: {

                            screenshotView?.alpha = 0.3

            }) { (finished: Bool) in
                dispatchGroup.leave()
            }

            dispatchGroup.enter()
            UIView.animate(withDuration: 0.1,
                           delay: completionDuration,
                           options: .curveEaseOut,
                           animations: {

                            contextViews.screenshotView?.alpha = 0.0
            }) { (finished: Bool) in
                dispatchGroup.leave()
            }

            dispatchGroup.notify(queue: .main) {
                
                transitionContext.completeTransition(true)
            }
        }
    }
}
