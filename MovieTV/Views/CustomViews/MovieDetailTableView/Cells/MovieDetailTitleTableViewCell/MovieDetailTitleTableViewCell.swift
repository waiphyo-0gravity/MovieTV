//
//  MovieDetailTitleTableViewCell.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/10/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

class MovieDetailTitleTableViewCell: UITableViewCell, NibableCellProtocol {

    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    
    @IBAction func handleClickedWishListBtn(_ sender: Any) {
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
    
    private func initial() {
        wishListBtn.layer.cornerRadius = 18
        wishListBtn.layer.shadowOffset = .init(width: -1, height: -2)
        wishListBtn.layer.shadowRadius = 20
        wishListBtn.layer.shadowPath = nil
        wishListBtn.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        wishListBtn.layer.shadowOpacity = 1
        
        pgLblBgView.layer.cornerRadius = 8
        pgLblBgView.layer.borderWidth = 2
        pgLblBgView.layer.borderColor = UIColor.S70.cgColor
        
        releasedDateBgView.layer.cornerRadius = 8
    }
    
    @IBOutlet weak var movieTitleLbl: UILabel!
    @IBOutlet weak var movieReleasedDateLbl: UILabel!
    @IBOutlet weak var pgLbl: UILabel!
    @IBOutlet weak var movieDurationLbl: UILabel!
    @IBOutlet weak var wishListBtn: MovieTVButton!
    @IBOutlet weak var pgLblBgView: UIView!
    @IBOutlet weak var releasedDateBgView: UIView!
}
