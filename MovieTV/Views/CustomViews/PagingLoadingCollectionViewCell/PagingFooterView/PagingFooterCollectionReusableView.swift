//
//  PagingFooterCollectionReusableView.swift
//  MovieTV
//
//  Created by ZeroGravity on 3/7/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

class PagingFooterCollectionReusableView: UICollectionReusableView, NibableCellProtocol {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initial()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    
    private func initial() {
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        activityIndicator.startAnimating()
    }
    
    let activityIndicator: UIActivityIndicatorView = {
        let temp = UIActivityIndicatorView()
        temp.color = UIColor.Primary100
        temp.style = .medium
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
}
