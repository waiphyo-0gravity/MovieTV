//
//  MovieDetailCastTableViewCell.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/10/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

class MovieDetailCastTableViewCell: UITableViewCell, NibableCellProtocol {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var castCollectionView: MovieDetailCastCollectionView!
}
