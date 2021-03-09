//
//  MovieDetailTitleTableViewCell.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/10/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol MovieDetailTitleTableViewCellDelegate: AnyObject {
    func handleClickedFavorite()
}

class MovieDetailTitleTableViewCell: UITableViewCell, NibableCellProtocol {

    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    
    @IBAction func handleClickedFavoriteBtn(_ sender: Any) {
        isFavourate.toggle()
        setFavourate(isFavourate: isFavourate, isAnimate: true)
        delegate?.handleClickedFavorite()
    }
    
    func setDuration(from second: Int?) {
        guard let second = second else {
            movieDurationLbl.text = nil
            return
        }
        
        movieDurationLbl.text = "\(Int(second / 60))h \(Int(second % 60))m"
    }
    
    func setReleaseDate(date: String?) {
        if let date = DateFomatterHelper.getDate(from: date, dateStringFormat: .year_month_day_dash) {
            let isReleased = Date() >= date
            
            releasedDateBgView.backgroundColor = isReleased ? .G100 : .systemOrange
        }
        
        movieReleasedDateLbl.text = DateFomatterHelper.changeDateFormat(from: date, fromFormat: .year_month_day_dash, toFormat: .day_month_year)
    }
    
    func setFavourate(isFavourate: Bool, isAnimate: Bool) {
        if isAnimate {
            favoriteBtn.bounceAnimation()
        }
        
        self.favoriteBtn.setImage(UIImage(named: isFavourate ? "favorite_l_fill_icon" : "favorite_fill_icon"), for: .normal)
        
        UIView.easeSpringAnimation(isAnimate: isAnimate) {
            self.favoriteBtn.backgroundColor = isFavourate ? .white : .P300
            self.favoriteBtn.tintColor = isFavourate ? .P300 : .white
        }
    }
    
    private func initial() {
        favoriteBtn.layer.cornerRadius = 18
        favoriteBtn.addAccentShadow()
        
        pgLblBgView.layer.cornerRadius = 8
        pgLblBgView.layer.borderWidth = 2
        pgLblBgView.layer.borderColor = UIColor.S70.cgColor
        
        releasedDateBgView.layer.cornerRadius = 8
    }
    
    @IBOutlet weak var movieTitleLbl: UILabel!
    @IBOutlet weak var movieReleasedDateLbl: UILabel!
    @IBOutlet weak var pgLbl: UILabel!
    @IBOutlet weak var movieDurationLbl: UILabel!
    @IBOutlet weak var favoriteBtn: MovieTVButton!
    @IBOutlet weak var pgLblBgView: UIView!
    @IBOutlet weak var releasedDateBgView: UIView!
    
    weak var delegate: MovieDetailTitleTableViewCellDelegate?
    var isFavourate: Bool = false
}
