//
//  TagCollectionView.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/27/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

class TagCollectionView: UICollectionView {
    var data = [GenreModel]()
    
    var isSelectionEnable: Bool = true {
        didSet {
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    
    private func initial() {
        register(TagCollectionViewCell.createNib(), forCellWithReuseIdentifier: TagCollectionViewCell.CELL_IDENTIFIER)
        contentInset = .init(top: 0, left: 26, bottom: 0, right: 26)
        clipsToBounds = false
        allowsSelection = false
        dataSource = self
        delegate = self
    }
}

//  MARK: - Collection view delegates.
extension TagCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, TagCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.CELL_IDENTIFIER, for: indexPath) as? TagCollectionViewCell else { return UICollectionViewCell() }
        
        cell.data = data[indexPath.row]
        cell.delegate = self
        cell.actionBtn.isUserInteractionEnabled = isSelectionEnable
        cell.statusSignView.isHidden = !isSelectionEnable
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ceil(data[indexPath.row].name.size(withAttributes: [NSAttributedString.Key.font: TagCollectionViewCell.tagNameFont]).width)
        return .init(width: width + 40, height: 34)
    }
    
    func handleTagSelection(for cell: UICollectionViewCell) {
        guard let indexPath = indexPath(for: cell) else { return }
        
        data[indexPath.row].isSelected.toggle()
    }
}
