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
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        let container = transitionContext.containerView
            
        let moveLeft = CGAffineTransform(translationX: -container.frame.width, y: 0)
        let moveRight = CGAffineTransform(translationX: container.frame.width, y: 0)
        
        if isPresenting {
            toView.transform = moveRight
            snapshot = fromView.snapshotView(afterScreenUpdates: true)
            container.addSubview(toView)
            container.addSubview(snapshot!)
        }
        
        UIView.animate(withDuration: duration, animations: {
            
            if self.isPresenting {
                
                self.snapshot?.transform = moveLeft
                toView.transform = CGAffineTransform.identity
                
            } else {
                
                self.snapshot?.transform = CGAffineTransform.identity
                fromView.transform = moveRight
                
            }
            
            }, completion: { finished in
                
                transitionContext.completeTransition(true)
                
                if !self.isPresenting {
                    self.snapshot?.removeFromSuperview()
                }
        })
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresenting = true
        
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresenting = false
        return self
    }
    
}
