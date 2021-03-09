//
//  MenuSideNavTableViewCell.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/21/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol MenuSideNavTableViewCellDelegate: AnyObject {
    func handleSideNavSelection(for cell: UITableViewCell)
}

class MenuSideNavTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var actionBtn: MovieTVButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var navTitleLbl: UILabel!
    @IBOutlet weak var imgContainerView: UIView!
    
    weak var delegate: MenuSideNavTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    
    private func initial() {
        actionBtn.specificAnimateView = containerView
        imgContainerView.layer.cornerRadius = 32 / 2
        imgContainerView.addAccentShadow(with: .init(roundedRect: imgContainerView.frame, cornerWidth: 32/2, cornerHeight: 32/2, transform: nil))
    }
    
    @IBAction func clickedActionBtn(_ sender: Any) {
        delegate?.handleSideNavSelection(for: self)
    }
}
