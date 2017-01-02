//
//  SlideRightTransitionManager.swift
//  CL
//
//  Created by iwritecode on 1/2/17.
//  Copyright © 2017 iwritecode. All rights reserved.
//

import UIKit

class SlideRightTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    let duration = 0.2
    var isPresenting = false
    
    var snapshot: UIView?
    
    var fromVC: UIViewController?
    var toVC: UIViewController?
    
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        guard let container = transitionContext.containerView() else {
            return
        }
        
        let moveLeft = CGAffineTransformMakeTranslation(-container.frame.width, 0)
        let moveRight = CGAffineTransformMakeTranslation(container.frame.width, 0)
        
        if isPresenting {
            toView.transform = moveRight
            snapshot = fromView.snapshotViewAfterScreenUpdates(true)
            container.addSubview(toView)
            container.addSubview(snapshot!)
        }
        
        UIView.animateWithDuration(duration, animations: {
            
            if self.isPresenting {
                
                self.snapshot?.transform = moveLeft
                toView.transform = CGAffineTransformIdentity
                
            } else {
                
                self.snapshot?.transform = CGAffineTransformIdentity
                fromView.transform = moveRight
                
            }
            
            }, completion: { finished in
                
                transitionContext.completeTransition(true)
                
                if !self.isPresenting {
                    self.snapshot?.removeFromSuperview()
                }
        })
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresenting = true
        
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresenting = false
        return self
    }
    
}
