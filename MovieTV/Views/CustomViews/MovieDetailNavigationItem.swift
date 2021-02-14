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
        temp.layer.shadowOffset = .init(width: -1, height: -2)
        temp.layer.shadowRadius = 20
        temp.layer.shadowPath = nil
        temp.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        temp.layer.shadowOpacity = 1
        temp.backgroundColor = .S10
        temp.setImage(UIImage(named: "back_icon"), for: .normal)
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
    }
}
