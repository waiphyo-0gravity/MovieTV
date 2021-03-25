//
//  UIApplication+Extension.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/21/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit
import Lottie

extension UIApplication {
    var firstKeyWindow: UIWindow? {
        return windows.first(where: { $0.isKeyWindow })
    }
}

extension AnimationView {
    func changeAnimation(with name: String, autoPlay: Bool = true) {
        DispatchQueue.global(qos: .background).async {[weak self] in
            let animation = Animation.named(name)
            
            DispatchQueue.main.async {
                self?.animation = animation
                
                if autoPlay {
                    self?.play()
                }
            }
        }
    }
}
