//
//  MoviesCollectionView.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/28/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol MoviesCollectionViewDelegate: AnyObject {
    func choosedMovie(at indexPath: IndexPath)
}

class MoviesCollectionView: UICollectionView {
    
    weak var customDelegate: MoviesCollectionViewDelegate?
    
    var data: [MovieModel] = [] {
        didSet {
            reloadData()
        }
    }
    
    private let cellWidth: CGFloat = UIScreen.main.bounds.width - 70 * 2
    
    private var horizontalContentInset: CGFloat {
        return (UIScreen.main.bounds.width / 2) - (cellWidth / 2)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    
    private func initial() {
        register(MoviesCollectionViewCell.createNib(), forCellWithReuseIdentifier: MoviesCollectionViewCell.CELL_IDENTIFIER)
        contentInset = .init(top: 0, left: horizontalContentInset, bottom: 0, right: horizontalContentInset)
        dataSource = self
        delegate = self
    }
    
}

//  MARK: - Collection view delegates.
extension MoviesCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MoviesCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCell.CELL_IDENTIFIER, for: indexPath) as? MoviesCollectionViewCell else { return UICollectionViewCell() }
        
        cell.data = data[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionViewLayout.collectionView?.frame.height ?? 0
        
        return .init(width: cellWidth, height: height)
    }
    
    func clickedMovie(for cell: UICollectionViewCell) {
        guard let indexPath = indexPath(for: cell) else { return }
        
        customDelegate?.choosedMovie(at: indexPath)
    }
}
