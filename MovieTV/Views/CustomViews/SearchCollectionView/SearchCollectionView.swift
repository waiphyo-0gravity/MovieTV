//
//  SearchCollectionView.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/24/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol SearchCollectionViewDelegate: AnyObject {
    func handleSelectedMovie(at index: Int)
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    func reachPaging()
}

extension SearchCollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {}
}

class SearchCollectionView: UICollectionView {
    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    
    private func initial() {
        register(SearchCollectionViewCell.createNib(), forCellWithReuseIdentifier: SearchCollectionViewCell.CELL_IDENTIFIER)
        register(PagingFooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: PagingFooterCollectionReusableView.CELL_IDENTIFIER)
        contentInset = .init(top: 20, left: 26, bottom: safeAreaInsets.bottom, right: 26)
        backgroundColor = .clear
        dataSource = self
        delegate = self
    }
    
    weak var customDelegate: SearchCollectionViewDelegate?
    var isPagingInclude: Bool = false
    
    var data = [MovieModel]() {
        didSet {
            reloadData()
        }
    }
    
    private var cellSize: CGSize {
        let width = (UIScreen.main.bounds.width - 25 - contentInset.left - contentInset.right) / 2
        return .init(width: width, height: 277)
    }
}

//  MARK: - Table view datasources & delegate
extension SearchCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SearchCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return getMovieCell(cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PagingFooterCollectionReusableView.CELL_IDENTIFIER, for: indexPath) as? PagingFooterCollectionReusableView else { return UICollectionReusableView() }
        
        return reusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return isPagingInclude ? .init(width: UIScreen.main.bounds.width, height: 20) : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard elementKind == UICollectionView.elementKindSectionFooter else { return }
        
        customDelegate?.reachPaging()
    }
    
    private func getMovieCell(cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.CELL_IDENTIFIER, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        
        let currentData = data[indexPath.row]

        let imgUrl = URLHelper.Image.customWidth(500, currentData.posterPath).urlStr

        cell.imgView.setImg(url: imgUrl)
        cell.movieNameLbl.text = currentData.title
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard indexPath.row < data.count else {
            return .init(width: UIScreen.main.bounds.width, height: 20)
        }
        
        return cellSize
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customDelegate?.scrollViewDidScroll(scrollView)
    }
    
    func handleSelectedMovie(for cell: UICollectionViewCell) {
        guard let indexPath = indexPath(for: cell) else { return }
        
        customDelegate?.handleSelectedMovie(at: indexPath.row)
    }
}
