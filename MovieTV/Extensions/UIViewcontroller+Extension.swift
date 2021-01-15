//
//  UIViewcontroller+Extension.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/13/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

extension UIViewController {
    @nonobjc class var MainViewController: UIViewController? {
        return UIStoryboard.Main?.instantiateViewController(withIdentifier: "mainviewcontroller")
    }
    
    @nonobjc class var LoginViewController: UIViewController? {
        return UIStoryboard.Login?.instantiateViewController(withIdentifier: "loginviewcontroller")
    }
}
