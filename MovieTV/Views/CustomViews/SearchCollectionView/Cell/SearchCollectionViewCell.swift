//
//  SearchCollectionViewCell.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/24/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol SearchCollectionViewCellDelegate: AnyObject {
    func handleSelectedMovie(for cell: UICollectionViewCell)
}

class SearchCollectionViewCell: UICollectionViewCell, NibableCellProtocol {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 28
        actionBtn.specificAnimateView = self
    }
    
    @IBAction func clickedActionBtn(_ sender: Any) {
        delegate?.handleSelectedMovie(for: self)
    }
    
    @IBOutlet weak var actionBtn: MovieTVButton!
    @IBOutlet weak var movieNameLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    weak var delegate: SearchCollectionViewCellDelegate?
}
