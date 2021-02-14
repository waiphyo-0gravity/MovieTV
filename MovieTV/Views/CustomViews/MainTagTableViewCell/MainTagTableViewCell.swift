//
//  MainTagTableViewCell.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/20/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

class MainTagTableViewCell: UITableViewCell, NibableCellProtocol {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    @IBOutlet weak var collectionView: TagCollectionView!
}
