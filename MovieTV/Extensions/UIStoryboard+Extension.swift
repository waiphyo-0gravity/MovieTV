//
//  UIStoryboard+Extension.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/13/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

extension UIStoryboard {
    @nonobjc class var Main: UIStoryboard? {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    @nonobjc class var Login: UIStoryboard? {
        return UIStoryboard(name: "Login", bundle: nil)
    }
    
    @nonobjc class var MovieDetail: UIStoryboard? {
        return UIStoryboard(name: "MovieDetail", bundle: nil)
    }
    
    @nonobjc class var MainContainer: UIStoryboard? {
        return UIStoryboard(name: "MainContainer", bundle: nil)
    }
    
    @nonobjc class var Menu: UIStoryboard? {
        return UIStoryboard(name: "Menu", bundle: nil)
    }
    
    @nonobjc class var Search: UIStoryboard? {
        return UIStoryboard(name: "Search", bundle: nil)
    }
    
    @nonobjc class var AccountMovies: UIStoryboard? {
        return UIStoryboard(name: "AccountMovies", bundle: nil)
    }
    
    @nonobjc class var AboutMe: UIStoryboard? {
        return UIStoryboard(name: "AboutMe", bundle: nil)
    }
}
