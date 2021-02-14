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
    
    private func initial() {
        wishListBtn.layer.cornerRadius = 18
    }
    
    @IBOutlet weak var movieTitleLbl: UILabel!
    @IBOutlet weak var movieReleasedDateLbl: UILabel!
    
    @IBOutlet weak var pgLbl: UILabel!
    @IBOutlet weak var movieDurationLbl: UILabel!
    @IBOutlet weak var wishListBtn: MovieTVButton!
}
