//
//  MainNavigationItem.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/21/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

class MainNavigationItem: UINavigationItem {
    
    let menuBtn: MovieTVButton = {
        let temp = MovieTVButton()
        temp.tintColor = UIColor(named: "Primary100")
        temp.setImage(UIImage(named: "menu_icon"), for: .normal)
        return temp
    }()
    
    let searchBtn: MovieTVButton = {
        let temp = MovieTVButton()
        temp.tintColor = UIColor(named: "Primary100")
        temp.setImage(UIImage(named: "search_icon"), for: .normal)
        return temp
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    private func configure() {
//        MARK: left nav item set up.
        let leftSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftSpace.width = 16
        let menuBarBtn = UIBarButtonItem(customView: menuBtn)
        leftBarButtonItems = [leftSpace, menuBarBtn]
        
//        MARK: right nav item set up.
        let rightSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        rightSpace.width = 16
        let searchBarBtn = UIBarButtonItem(customView: searchBtn)
        rightBarButtonItems = [rightSpace, searchBarBtn]
    }
}
