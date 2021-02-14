//
//  MovieDetailRatingTableViewCell.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/10/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

class MovieDetailRatingTableViewCell: UITableViewCell, NibableCellProtocol {
    
    let containerViewCornerRadius: CGFloat = 96 / 2
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    
    private func initial() {
        contentView.layer.masksToBounds = false
        backgroundColor = .clear
        
        setUpContainerView()
        ratingRatioLbl.text = "8.2/10"
        ratingCountLbl.text = "150,212"
    }
    
    private func setUpContainerView() {
        containerView.layer.cornerRadius = containerViewCornerRadius
        containerView.layer.shadowOffset = .init(width: -1, height: -2)
        containerView.layer.shadowRadius = 20
        containerView.layer.shadowPath = nil
        containerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        containerView.layer.shadowOpacity = 1
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ratingRatioLbl: UILabel!
    @IBOutlet weak var ratingCountLbl: UILabel!
    @IBOutlet weak var ratingBtn: UIButton!
    @IBOutlet weak var rateThisLbl: UILabel!
}
