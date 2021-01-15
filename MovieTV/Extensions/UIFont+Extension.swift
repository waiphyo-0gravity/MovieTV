//
//  UIFont+Extensions.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/14/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

extension UIFont {
    enum FontStyle: String {
        case regular = "Calibri"
    }
    
    @nonobjc class var small: UIFont {
        return UIFont(name: FontStyle.regular.rawValue, size: 13)!
    }
    
    @nonobjc class var light_body_l: UIFont? {
        return UIFont(name: FontStyle.regular.rawValue, size: 17)!
    }
}
