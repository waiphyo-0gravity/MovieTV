//
//  UIViewcontroller+Extension.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/13/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

extension UIViewController {
    @nonobjc class var MainNavViewController: UIViewController? {
        return UIStoryboard.Main?.instantiateViewController(withIdentifier: "menunavigationcontroller")
    }
    
    @nonobjc class var MainViewController: UIViewController? {
        return UIStoryboard.Main?.instantiateViewController(withIdentifier: "mainviewcontroller")
    }
    
    @nonobjc class var LoginViewController: UIViewController? {
        return UIStoryboard.Login?.instantiateViewController(withIdentifier: "loginviewcontroller")
    }
    
    @nonobjc class var MovieDetailViewController: UIViewController? {
        return UIStoryboard.MovieDetail?.instantiateViewController(withIdentifier: "moviedetailviewcontroller")
    }
    
    @nonobjc class var MainContainerViewController: UIViewController? {
        return UIStoryboard.MainContainer?.instantiateViewController(withIdentifier: "maincontainerviewcontroller")
    }
    
    @nonobjc class var MenuViewController: UIViewController? {
        return UIStoryboard.Menu?.instantiateViewController(withIdentifier: "menuviewcontroller")
    }
    
    @nonobjc class var SearchViewController: UIViewController? {
        return UIStoryboard.Search?.instantiateViewController(withIdentifier: "searchviewcontroller")
    }
    
    @nonobjc class var AccountMoviesViewController: UIViewController? {
        return UIStoryboard.AccountMovies?.instantiateViewController(withIdentifier: "accountmoviesviewcontroller")
    }
    
    @nonobjc class var RatingViewController: UIViewController? {
        return UIStoryboard.MovieDetail?.instantiateViewController(withIdentifier: "ratingviewcontroller")
    }
}
