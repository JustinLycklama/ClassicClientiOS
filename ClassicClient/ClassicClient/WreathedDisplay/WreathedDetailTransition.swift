//
//  HorizontalItemTransition.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-08-12.
//

import UIKit

public class WreathedDetailTransition: NSObject, UIViewControllerAnimatedTransitioning { 

    public var fromView: UIView?
    public var viewContainer: UIView?
    public var presenting: Bool = false
    
    private var endingFrameForWreathInPresentation: CGRect?
    
    struct ContextViews {
        var maskView: UIView?
        var wreathedDetailView: WreathedDetailView
        var originFrame: CGRect
    }
    
    private let completionDuration = 0.75
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.9
    }
    
    private func getContextViews(inContainer containerView: UIView) -> ContextViews {
        var maskView: UIView? = nil
        var originFrame: CGRect?
        
        if let view = fromView,
            let container = viewContainer {
            
            originFrame = container.convert(view.frame, to: containerView)
                        
            maskView = UIView()
            maskView?.backgroundColor = .black
            maskView?.alpha = 1
            maskView?.layer.cornerRadius = WreathedDetailView.CornerRaduis
        }
        
        var wreathedDetailView = WreathedDetailView()
        containerView.addSubview(wreathedDetailView)
        
        return ContextViews(maskView: maskView, wreathedDetailView: wreathedDetailView, originFrame: originFrame ?? .zero)
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                return
        }

        
        let finalFrameForVC = transitionContext.finalFrame(for: toViewController)

        let containerView = transitionContext.containerView
        let containerContentView = UIView()
        
        containerView.addSubview(containerContentView)
        containerContentView.frame = finalFrameForVC
                
        if presenting {
            toViewController.view.frame = finalFrameForVC
            containerView.addSubview(toViewController.view)
            
            let contextViews = getContextViews(inContainer: containerContentView)
                        
            contextViews.wreathedDetailView.frame = contextViews.originFrame
            
            toViewController.view.mask = contextViews.maskView
            toViewController.view.alpha = 0.15
            
            let totalDuration = transitionDuration(using: transitionContext)
            
            let clickDuration = 0.20
            let remainingDuration = totalDuration - clickDuration
            
            let secondaryDuration = remainingDuration * 0.66
            let finalDuration = remainingDuration * 0.33
            
            let dispatchGroup = DispatchGroup()
            
            containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
            

            fromView?.alpha = 0
            
            // Do the cell 'select' animation
            dispatchGroup.enter()
            UIView.animateKeyframes(withDuration: clickDuration, delay: 0.0, options: .calculationModeCubic, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                    contextViews.wreathedDetailView.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                    contextViews.wreathedDetailView.transform = .identity
                })
            }) { (completed: Bool) in
                dispatchGroup.leave()
                self.fromView?.alpha = 1
            }
                
            
            
            dispatchGroup.enter()
            UIView.animate(withDuration: secondaryDuration,
                           delay: clickDuration,
                           options: .curveEaseIn,
                           animations: {
                                                        
                            contextViews.wreathedDetailView.translatesAutoresizingMaskIntoConstraints = false
                            containerContentView.addConstraints(NSLayoutConstraint.constraints(
                                givenContext: WreathedDetailViewController.constraintContext,
                                forView: contextViews.wreathedDetailView))
                            
                            containerContentView.layoutIfNeeded()
                            
            }) { (finished: Bool) in
                
                contextViews.maskView?.frame = contextViews.wreathedDetailView.frame
                self.endingFrameForWreathInPresentation = contextViews.wreathedDetailView.frame
                
                UIView.animate(withDuration: finalDuration,
                                   delay: 0,
                                   options: .curveEaseOut,
                                   animations: {
                                    
                                    toViewController.view.alpha = 1
                                    contextViews.maskView?.frame = finalFrameForVC

                                    
                }) { (finished: Bool) in
                    toViewController.view.mask = nil
                    contextViews.wreathedDetailView.removeFromSuperview()
                    containerContentView.removeFromSuperview()
                    
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                transitionContext.completeTransition(true)
            }
        } else {
            let contextViews = getContextViews(inContainer: containerContentView)

            contextViews.maskView?.frame = finalFrameForVC

            let dispatchGroup = DispatchGroup()

            fromViewController.view.alpha = 1
            fromViewController.view.mask = contextViews.maskView
            
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            
            
            let fadeInFakeWreathDuration = 0.15 * completionDuration
            
            contextViews.wreathedDetailView.alpha = 0
            contextViews.wreathedDetailView.isOpaque = false
            
              dispatchGroup.enter()
              UIView.animate(withDuration: fadeInFakeWreathDuration,
                             delay: 0.0,
                             options: .curveEaseOut,
                             animations: {

                                contextViews.maskView?.frame = self.endingFrameForWreathInPresentation ?? .zero
                                contextViews.wreathedDetailView.alpha = 1

              }) { (finished: Bool) in
                  dispatchGroup.leave()
              }
            
            contextViews.wreathedDetailView.frame = endingFrameForWreathInPresentation ?? .zero
            
            dispatchGroup.enter()
            UIView.animate(withDuration: completionDuration - fadeInFakeWreathDuration,
                           delay: fadeInFakeWreathDuration,
                           options: .curveEaseOut,
                           animations: {
                            
                            contextViews.maskView?.frame = contextViews.originFrame
                            contextViews.wreathedDetailView.frame = contextViews.originFrame

            }) { (finished: Bool) in
                fromViewController.view.mask = nil
                
                contextViews.wreathedDetailView.removeFromSuperview()
                containerContentView.removeFromSuperview()
                
                dispatchGroup.leave()
            }

//            dispatchGroup.enter()
//            UIView.animate(withDuration: completionDuration * 0.3,
//                           delay: completionDuration * 0.7,
//                           options: .curveEaseOut,
//                           animations: {
//
//                            wreathedDetailView.alpha = 0.3
//
//            }) { (finished: Bool) in
//                dispatchGroup.leave()
//            }

//            dispatchGroup.enter()
//            UIView.animate(withDuration: 0.1,
//                           delay: completionDuration,
//                           options: .curveEaseOut,
//                           animations: {
//
//                            contextViews.wreathedDetailView.alpha = 0.0
//            }) { (finished: Bool) in
//                contextViews.wreathedDetailView.removeFromSuperview()
//                containerContentView.removeFromSuperview()
//
//                dispatchGroup.leave()
//            }

            dispatchGroup.notify(queue: .main) {
                transitionContext.completeTransition(true)
            }
        }
    }
}
