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
    
    func touchAroundToHideKeyboard(delegate: UIGestureRecognizerDelegate? = nil) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        tapGesture.delegate = delegate
    }
    
    @objc private func handleTap() {
        endEditing(true)
    }
}
