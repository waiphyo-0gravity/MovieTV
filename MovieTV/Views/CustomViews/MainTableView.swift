//
//  MainTableViewController.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/20/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol MainTableViewDelegate: AnyObject {
    func choosedMovie(at indexPath: IndexPath)
    func changedMovieType(to type: MainViewModel.MovieListType)
}

class MainTableView: UITableView {
    
    weak var customDelegate: MainTableViewDelegate?
    
    var tagData: [GenreModel] = []
    
    var titleData = MainViewModel.MovieListType.allCases
    
    var movieListData: [MovieModel]? {
        didSet {
            beginUpdates()
            reloadRows(at: [IndexPath(row: 2, section: 0)], with: oldValue == nil ? .fade : .none)
            endUpdates()
        }
    }
    
    private var dispatchWorkItem: DispatchWorkItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
    }
    
    func changeTagData(to data: [GenreModel]) {
        let animation: UITableView.RowAnimation = tagData.count == 0 ? .fade : .none
        
        tagData = data
        beginUpdates()
        reloadRows(at: [IndexPath(row: 1, section: 0)], with: animation)
        endUpdates()
    }
    
    private func config() {
        register(MainTitleTableViewCell.createNib(), forCellReuseIdentifier: MainTitleTableViewCell.CELL_IDENTIFIER)
        register(MainTagTableViewCell.createNib(), forCellReuseIdentifier: MainTagTableViewCell.CELL_IDENTIFIER)
        register(MainBodyTableViewCell.createNib(), forCellReuseIdentifier: MainBodyTableViewCell.CELL_IDENTIFIER)
        tableFooterView = UIView()
        allowsSelection = false
        separatorColor = .clear
        dataSource = self
        delegate = self
    }
}

//  MARK: - Table view delegates & datasources.
extension MainTableView: UITableViewDataSource, UITableViewDelegate, MainBodyTableViewCellDelegate, MainTitleTableViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return getTitleCell(for: indexPath)
        case 1:
            return getTagCell(for: indexPath)
        case 2:
            return getBodyCell(for: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    private func getTitleCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: MainTitleTableViewCell.CELL_IDENTIFIER, for: indexPath) as? MainTitleTableViewCell else {
            return UITableViewCell()
        }
        
        cell.collectionView.data = titleData
        cell.delegate = self
        
        return cell
    }
    
    private func getTagCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: MainTagTableViewCell.CELL_IDENTIFIER, for: indexPath) as? MainTagTableViewCell else {
            return UITableViewCell()
        }
        
        cell.collectionView.data = tagData
        cell.collectionView.reloadData()
        
        return cell
    }
    
    private func getBodyCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: MainBodyTableViewCell.CELL_IDENTIFIER, for: indexPath) as? MainBodyTableViewCell else {
            return UITableViewCell()
        }
        
        
        cell.movieCollectionView.data = movieListData ?? []
        cell.delegate = self
        
        return cell
    }
    
    func handleMovieTypeChanged(to type: MainViewModel.MovieListType) {
        guard let cell = cellForRow(at: IndexPath(row: 2, section: 0)) as? MainBodyTableViewCell,
              cell.movieCollectionView.data.count != 0 else {
            customDelegate?.changedMovieType(to: type)
            return
        }
        
        dispatchWorkItem?.cancel()
        
        dispatchWorkItem = DispatchWorkItem(block: {[weak self] in
            self?.customDelegate?.changedMovieType(to: type)
            self?.dispatchWorkItem = nil
        })
        
        cell.movieCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
        
        guard let dispatchWorkItem = dispatchWorkItem else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: dispatchWorkItem)
    }
    
    func choosedMovie(at indexPath: IndexPath) {
        customDelegate?.choosedMovie(at: indexPath)
    }
}
