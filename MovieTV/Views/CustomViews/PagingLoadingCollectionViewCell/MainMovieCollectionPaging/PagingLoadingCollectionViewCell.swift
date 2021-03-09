//
//  PagingLoadingCollectionViewCell.swift
//  MovieTV
//
//  Created by ZeroGravity on 3/7/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

class PagingLoadingCollectionViewCell: UICollectionViewCell, NibableCellProtocol {

    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    
    private func initial() {
        containerView.layer.cornerRadius = 42
        containerView.backgroundColor = UIColor(named: "S10")
    }

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIView!
}
