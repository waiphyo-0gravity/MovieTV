//
//  MovieDetailTableView.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/10/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol MovieDetailTableViewDelegate: AnyObject {
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    func handleClickedFavorite()
}

class MovieDetailTableView: UITableView {
    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    
    private func initial() {
        register(MovieDetailTitleTableViewCell.createNib(), forCellReuseIdentifier: MovieDetailTitleTableViewCell.CELL_IDENTIFIER)
        register(MainTagTableViewCell.createNib(), forCellReuseIdentifier: MainTagTableViewCell.CELL_IDENTIFIER)
        register(MovieDetailSummaryTableViewCell.createNib(), forCellReuseIdentifier: MovieDetailSummaryTableViewCell.CELL_IDENTIFIER)
        register(MovieDetailCastTableViewCell.createNib(), forCellReuseIdentifier: MovieDetailCastTableViewCell.CELL_IDENTIFIER)
        delegate = self
        dataSource = self
        allowsSelection = false
        tableFooterView = UIView()
        separatorColor = .clear
        backgroundColor = .clear
        contentInset = .init(top: Self.topInset, left: 0, bottom: 0, right: 0)
    }
    
    private func handleDataChanged() {
        beginUpdates()
        reloadRows(at: [
                    IndexPath(row: 0, section: 0),
                    IndexPath(row: 3, section: 0)
        ], with: .automatic)
        endUpdates()
    }
    
    weak var customDelegate: MovieDetailTableViewDelegate?
    
    var data: MovieModel? {
        didSet {
            reloadData()
        }
    }
    
    var isGuestUser: Bool = false
    
    var isFavourate: Bool = false {
        didSet {
            let indexPath = IndexPath(row: 0, section: 0)
            guard let cell = cellForRow(at: indexPath) as? MovieDetailTitleTableViewCell else {
                beginUpdates()
                reloadRows(at: [indexPath], with: .automatic)
                endUpdates()
                return
            }
            
            cell.isFavourate = isFavourate
            cell.setFavourate(isFavourate: isFavourate, isAnimate: true)
        }
    }
    
    var movieDetailData: MovieDetailModel? {
        didSet {
            handleDataChanged()
        }
    }
    
    var certificatedRating: String? {
        didSet {
            let currentCertificate = movieDetailData?.releases?.usableCertification?.certification
            guard certificatedRating != nil,
                  currentCertificate?.isEmpty != false || currentCertificate != certificatedRating else { return }
            
            handleDataChanged()
        }
    }
    
    static let topInset: CGFloat = MovieDetailViewController.coverBottomConstant + 64
}

//  MARK: - Table view delegates.
extension MovieDetailTableView: UITableViewDelegate, UITableViewDataSource, MovieDetailTitleTableViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row >= 3 else {
            return UITableView.automaticDimension
        }
        
        let isCastEmpty = (movieDetailData?.credits?.cast?.count ?? 0) == 0
        
        return isCastEmpty ? 0 : UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customDelegate?.scrollViewDidScroll(scrollView)
    }
    
    func handleClickedFavorite() {
        isFavourate.toggle()
        customDelegate?.handleClickedFavorite()
    }
    
    private func getCell(for indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return getTitleTableCell(for: indexPath)
        case 1:
            return getTagTableCell(for: indexPath)
        case 2:
            return getSummaryTableCell(for: indexPath)
        case 3:
            return getCastTableCell(for: indexPath)
        case 4:
            return getCrewTableCell(for: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    private func getTitleTableCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: MovieDetailTitleTableViewCell.CELL_IDENTIFIER, for: indexPath) as? MovieDetailTitleTableViewCell else { return UITableViewCell() }
        
        let pgTxt = certificatedRating ?? movieDetailData?.releases?.usableCertification?.certification
        
        cell.isFavourate = isFavourate
        cell.movieTitleLbl.text = data?.title
        cell.setReleaseDate(date: data?.releaseDate)
        
        if isGuestUser {
            cell.favoriteBtn.isHidden = true
        } else {
            cell.setFavourate(isFavourate: isFavourate, isAnimate: false)
        }
        
        cell.pgLbl.text = pgTxt
        cell.pgLblBgView.alpha = pgTxt?.isEmpty == false ? 1 : 0
        cell.setDuration(from: movieDetailData?.runtime)
        cell.delegate = self
        
        return cell
    }
    
    private func getTagTableCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: MainTagTableViewCell.CELL_IDENTIFIER, for: indexPath) as? MainTagTableViewCell else { return UITableViewCell() }
        
        cell.collectionView.data = GenresMapHelper.shared.mapGenres(for: data?.genreIDs)
        cell.collectionView.isSelectionEnable = false
        
        return cell
    }
    
    private func getSummaryTableCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: MovieDetailSummaryTableViewCell.CELL_IDENTIFIER, for: indexPath) as? MovieDetailSummaryTableViewCell else { return UITableViewCell() }
        
        cell.summaryLbl.text = data?.overview
        
        return cell
    }
    
    private func getCastTableCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: MovieDetailCastTableViewCell.CELL_IDENTIFIER, for: indexPath) as? MovieDetailCastTableViewCell else { return UITableViewCell() }
        
        cell.cellType = .cast
        cell.castCollectionView.data = movieDetailData?.credits?.cast ?? []
        
        return cell
    }
    
    private func getCrewTableCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: MovieDetailCastTableViewCell.CELL_IDENTIFIER, for: indexPath) as? MovieDetailCastTableViewCell else { return UITableViewCell() }
        
        cell.cellType = .crew
        cell.castCollectionView.data = movieDetailData?.credits?.crew ?? []
        
        return cell
    }
}
