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
        case bold = "Calibri-Bold"
    }
    
    @nonobjc class var small: UIFont {
        return UIFont(name: FontStyle.regular.rawValue, size: 13)!
    }
    
    @nonobjc class var light_body_l: UIFont? {
        return UIFont(name: FontStyle.regular.rawValue, size: 17)!
    }
    
    @nonobjc class var light_body_m: UIFont? {
        return UIFont(name: FontStyle.regular.rawValue, size: 15)!
    }
    
    @nonobjc class var h4_strong: UIFont? {
        return UIFont(name: FontStyle.bold.rawValue, size: 17)!
    }
}
