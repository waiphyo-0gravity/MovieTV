//
//  MovieDetailNavigationItem.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/7/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

class MovieDetailNavigationItem: UINavigationItem {
    let leftBackBtn: MovieTVButton = {
        let temp = MovieTVButton(frame: .init(x: 0, y: 0, width: 40, height: 40))
        temp.layer.cornerRadius = 40 / 2
        temp.addAccentShadow()
        temp.adjustsImageWhenHighlighted = false
        temp.backgroundColor = .S10
        temp.tintColor = .Primary100_Adapt
        temp.setImage(UIImage(named: "back_icon"), for: .normal)
        return temp
    }()
    
    lazy var watchListBtn: MovieTVButton = {
        let temp = MovieTVButton(frame: .init(x: 0, y: 0, width: 40, height: 40))
        temp.tintColor = .white
        temp.layer.cornerRadius = 40 / 2
        temp.addAccentShadow()
        temp.adjustsImageWhenHighlighted = false
        temp.backgroundColor = .Primary100
        temp.setImage(UIImage(named: "watchlist_fill_icon"), for: .normal)
        return temp
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpNavigationItem()
    }
    
    private func setUpNavigationItem() {
        let leftSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftSpace.width = 16
        let backBarButtonItem = UIBarButtonItem(customView: leftBackBtn)
        leftBarButtonItems = [leftSpace, backBarButtonItem]
        
        guard UserDefaultsHelper.shared.mappedUserType == .normal else { return }
        
        let rightSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        rightSpace.width = 16
        let favourateBarButtonItem = UIBarButtonItem(customView: watchListBtn)
        rightBarButtonItems = [rightSpace, favourateBarButtonItem]
    }
}
