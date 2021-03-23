//
//  MovieDetailCastCollectionView.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/12/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

class MovieDetailCastCollectionView: UICollectionView {
    
    var data = [MovieCreditsModel.CastCrewModel]() {
        didSet {
            reloadData()
        }
    }
    
    var cellType: MovieDetailCastTableViewCell.CellType = .cast
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    
    private func initial() {
        register(MovieDetailCastCollectionViewCell.createNib(), forCellWithReuseIdentifier: MovieDetailCastCollectionViewCell.CELL_IDENTIFIER)
        dataSource = self
        delegate = self
        contentInset = .init(top: 0, left: 26, bottom: 0, right: 26)
    }
}

extension MovieDetailCastCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(10, data.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieDetailCastCollectionViewCell.CELL_IDENTIFIER, for: indexPath) as? MovieDetailCastCollectionViewCell else { return UICollectionViewCell() }
        
        let currentData = data[indexPath.row]
        
        let url = URLHelper.Image.customWidth(200, currentData.profilePath).urlStr
        cell.castProfileImgView.setImg(url: url)
        cell.castNameLbl.text = currentData.name
        cell.castRoleLbl.text = cellType == .cast ? currentData.character : currentData.job
        
        return cell
    }
}
