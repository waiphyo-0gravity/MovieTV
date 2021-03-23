//
//  MovieTVTranstionHelper.swift
//  MovieTV
//
//  Created by ZeroGravity on 3/21/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

class MovieTVTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    private var isDismiss: Bool = false
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isDismiss = false
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isDismiss = true
        return self
    }
}

//  MARK: - Animated transitioning.
extension MovieTVTransitioningDelegate: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? UIViewController & TransitioningProtocol,
              let toVC = transitionContext.viewController(forKey: .to) as? UIViewController & TransitioningProtocol else {
            if !isDismiss, let toVC = transitionContext.viewController(forKey: .to) {
                transitionContext.containerView.addSubview(toVC.view)
            }
            transitionContext.completeTransition(true)
            return
        }
        
        if !isDismiss {
            toVC.transition(isShow: false, isAnimate: false, completion: nil)
            transitionContext.containerView.addSubview(toVC.view)
        }
        
        fromVC.beginAppearanceTransition(false, animated: true)
        toVC.beginAppearanceTransition(true, animated: true)
        
        fromVC.transition(isShow: false, isAnimate: true, completion: {_ in
            toVC.transition(isShow: true, isAnimate: true, completion: {_ in
                transitionContext.completeTransition(true)
                fromVC.endAppearanceTransition()
                toVC.endAppearanceTransition()
            })
        })
    }
}
