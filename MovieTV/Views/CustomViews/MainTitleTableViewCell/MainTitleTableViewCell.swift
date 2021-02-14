//
//  MainTitleTableViewCell.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/20/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol MainTitleTableViewCellDelegate: AnyObject {
    func handleMovieTypeChanged(to type: MainViewModel.MovieListType)
}

class MainTitleTableViewCell: UITableViewCell, NibableCellProtocol {
    
    weak var delegate: MainTitleTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.customDelegate = self
    }
    
    @IBOutlet weak var collectionView: FilterCollectionView!
}

//  MARK: - Filter collection view delegates.
extension MainTitleTableViewCell: FilterCollectionViewDelegate {
    func handleFilterChanged(to type: MainViewModel.MovieListType) {
        delegate?.handleMovieTypeChanged(to: type)
    }
}
