//
//  MovieDetailCastCollectionViewCell.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/12/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

class MovieDetailCastCollectionViewCell: UICollectionViewCell, NibableCellProtocol {

    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    
    private func initial() {
        castProfileImgView.layer.cornerRadius = 70 / 2
        actionBtn.specificAnimateView = self
    }
    
    @IBAction func handleClickedActionBtn(_ sender: Any) {
        
    }
    
    
//    MARK: - Outltes.
    @IBOutlet weak var castProfileImgView: UIImageView!
    @IBOutlet weak var castNameLbl: UILabel!
    @IBOutlet weak var castRoleLbl: UILabel!
    @IBOutlet weak var actionBtn: MovieTVButton!
}
