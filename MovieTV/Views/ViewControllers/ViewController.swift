//
//  ViewController.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/19/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol TransitioningProtocol {
    func transition(isShow: Bool, isAnimate: Bool, completion: ((Bool)->Void)?)
}

open class ViewController: UIViewController, TransitioningProtocol {
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }
    
    func transition(isShow: Bool, isAnimate: Bool, completion: ((Bool)->Void)? = nil) {
        completion?(true)
    }
}
