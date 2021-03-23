//
//  UIView+Extension.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/15/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

extension UIView {
    static func easeSpringAnimation(
        isAnimate: Bool = true,
        withDuration: TimeInterval = 0.5,
        delay: TimeInterval = 0,
        usingSpringWithDamping: CGFloat = 0.8,
        initialSpringVelocity: CGFloat = 0.8,
        options: UIView.AnimationOptions = [.curveEaseInOut],
        animations: @escaping () -> Void,
        completion: ((Bool)->Void)? = nil) {
        guard isAnimate else {
            animations()
            completion?(true)
            return
        }
        Self.animate(
            withDuration: withDuration,
            delay: delay,
            usingSpringWithDamping: usingSpringWithDamping,
            initialSpringVelocity: initialSpringVelocity,
            options: options,
            animations: animations, completion: completion)
    }
    
    func bounceAnimation() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25) {
                self.transform = .init(scaleX: 1.1, y: 1.1)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.25) {
                self.transform = .identity
            }
        }
    }
    
    func bouncePopUpAnimation(isAnimate: Bool = true, completion: ((Bool)->Void)? = nil) {
        guard isAnimate else {
            transform = .identity
            completion?(true)
            return
        }
        
//        transform = .init(scaleX: 0.0009, y: 0.0009)
        
        UIView.easeSpringAnimation(withDuration: 0.25, animations: {
            self.transform = .init(scaleX: 1.05, y: 1.05)
        })
        
        UIView.easeSpringAnimation(withDuration: 0.25, delay: 0.15, animations: {
            self.transform = .identity
        }, completion: completion)
    }
    
    func bouncePopDownAnimation(isAnimate: Bool = true, completion: ((Bool)->Void)? = nil) {
        guard isAnimate else {
            transform = .init(scaleX: 0.0009, y: 0.0009)
            completion?(true)
            return
        }
        
        UIView.easeSpringAnimation(withDuration: 0.25, animations: {
            self.transform = .init(scaleX: 1.05, y: 1.05)
        })
        
        UIView.easeSpringAnimation(withDuration: 0.25, delay: 0.15, animations: {
            self.transform = .init(scaleX: 0.0009, y: 0.0009)
        }, completion: completion)
    }
    
    func touchAroundToHideKeyboard(delegate: UIGestureRecognizerDelegate? = nil) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        tapGesture.delegate = delegate
    }
    
    func addAccentShadow(with path: CGPath? = nil) {
        layer.shadowOffset = .init(width: -1, height: -2)
        layer.shadowRadius = 20
        layer.shadowPath = path
        layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        layer.shadowOpacity = 1
    }
    
    @objc private func handleTap() {
        endEditing(true)
    }
}
