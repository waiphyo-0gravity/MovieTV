//
//  MovieDetailCastTableViewCell.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/10/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

class MovieDetailCastTableViewCell: UITableViewCell, NibableCellProtocol {

    enum CellType {
        case cast, crew
        
        var titleStr: String {
            switch self {
            case .cast:
                return "Top Billed Cast"
            case .crew:
                return "Crew"
            }
        }
        
        var topConstraint: CGFloat {
            switch self {
            case .cast:
                return 48
            case .crew:
                return 12
            }
        }
    }
    
    var cellType: CellType = .cast {
        didSet {
            castCollectionView.cellType = cellType
            titleLbl.text = cellType.titleStr
            titleTopConstraint.constant = cellType.topConstraint
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var castCollectionView: MovieDetailCastCollectionView!
}
