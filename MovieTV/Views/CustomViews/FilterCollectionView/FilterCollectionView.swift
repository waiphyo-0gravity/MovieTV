//
//  FilterCollectionView.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/23/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol FilterCollectionViewDelegate: AnyObject {
    func handleFilterChanged(to type: MainViewModel.MovieListType)
}

class FilterCollectionView: UICollectionView {
    let selectionView: UIView = {
        let temp = UIView(frame: .init(x: 0, y: 66, width: 34, height: 6))
        temp.backgroundColor = .systemOrange
        temp.layer.cornerRadius = 3
        return temp
    }()
    
    var data = [MainViewModel.MovieListType]() {
        didSet {
            reloadData()
        }
    }
    
    weak var customDelegate: FilterCollectionViewDelegate?
    
    private var currentSelectedIndex: Int = 0 {
        didSet {
            customDelegate?.handleFilterChanged(to: data[currentSelectedIndex])
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    
    private func initial() {
        register(FilterCollectionViewCell.createNib(), forCellWithReuseIdentifier: FilterCollectionViewCell.CELL_IDENTIFIER)
        contentInset = .init(top: 0, left: 26, bottom: 0, right: 26)
        allowsSelection = false
        dataSource = self
        delegate = self
        
        configSelectionView()
    }
    
    private func configSelectionView() {
        addSubview(selectionView)
        selectionView.layer.zPosition = 1000
    }
    
    private func moveSelectionView(to cell: UICollectionViewCell) {
        guard let indexPath = indexPath(for: cell) else { return }
        
        let currentWidth = min(32, self.collectionView(self, layout: self.collectionViewLayout, sizeForItemAt: indexPath).width)
        
        UIView.easeSpringAnimation(withDuration: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 1) {[weak self] in
            guard let self = self else { return }
            
            self.selectionView.frame.origin.x = cell.frame.origin.x
            self.selectionView.frame.size.width = currentWidth
        }
        
        DispatchQueue.main.async {[weak self] in
            self?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

//  MARK: - Collection view delegates.
extension FilterCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, FilterCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.CELL_IDENTIFIER, for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
        
        cell.nameLbl.text = data[indexPath.row].name
        cell.delegate = self
        cell.setSelect(indexPath.row == currentSelectedIndex, isAnimate: false)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ceil(data[indexPath.row].name.size(withAttributes: [NSAttributedString.Key.font: FilterCollectionViewCell.nameLblFont!]).width)
        return .init(width: width, height: 72)
    }
    
    func handleCellSelection(for cell: UICollectionViewCell) {
        defer {
            moveSelectionView(to: cell)
        }
        
        guard let indexPath = indexPath(for: cell),
              currentSelectedIndex != indexPath.row else { return }
        
        if let previousSelectedCell = cellForItem(at: IndexPath(item: currentSelectedIndex, section: 0)) as? FilterCollectionViewCell {
            previousSelectedCell.setSelect(false)
        } else {
            reloadItems(at: [IndexPath(row: currentSelectedIndex, section: 0)])
        }
        
        currentSelectedIndex = indexPath.row
    }
}
