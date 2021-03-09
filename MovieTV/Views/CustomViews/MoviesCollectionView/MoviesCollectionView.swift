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
    func reachPaging()
}

class MoviesCollectionView: UICollectionView {
    
    weak var customDelegate: MoviesCollectionViewDelegate?
    var isPagingInclude: Bool = false
    
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
        register(PagingLoadingCollectionViewCell.createNib(), forCellWithReuseIdentifier: PagingLoadingCollectionViewCell.CELL_IDENTIFIER)
        contentInset = .init(top: 0, left: horizontalContentInset, bottom: 0, right: horizontalContentInset)
        dataSource = self
        delegate = self
    }
    
}

//  MARK: - Collection view delegates.
extension MoviesCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MoviesCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count + (isPagingInclude ? 1 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch true {
        case indexPath.row < data.count:
            return getMovieCollectionCell(cellForItemAt: indexPath)
        default:
            return getPagingCell(cellForItemAt: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.row >= data.count else { return }
        
        customDelegate?.reachPaging()
    }
    
    private func getMovieCollectionCell(cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCell.CELL_IDENTIFIER, for: indexPath) as? MoviesCollectionViewCell else { return UICollectionViewCell() }
        
        cell.data = data[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    private func getPagingCell(cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: PagingLoadingCollectionViewCell.CELL_IDENTIFIER, for: indexPath) as? PagingLoadingCollectionViewCell else { return UICollectionViewCell() }
        
        cell.activityIndicator.startAnimating()
        
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
