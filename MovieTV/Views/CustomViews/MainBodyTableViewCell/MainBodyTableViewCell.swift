//
//  MainBodyTableViewCell.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/20/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol MainBodyTableViewCellDelegate: AnyObject {
    func choosedMovie(at indexPath: IndexPath)
    func reachPaging()
}

class MainBodyTableViewCell: UITableViewCell, NibableCellProtocol {
    
    @IBOutlet weak var movieCollectionView: MoviesCollectionView!
    
    weak var delegate: MainBodyTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.layer.masksToBounds = false
        
        movieCollectionView.customDelegate = self
    }
}

//  MARK: - Movie collection view delegates.
extension MainBodyTableViewCell: MoviesCollectionViewDelegate {
    func choosedMovie(at indexPath: IndexPath) {
        delegate?.choosedMovie(at: indexPath)
    }
    
    func reachPaging() {
        delegate?.reachPaging()
    }
}
