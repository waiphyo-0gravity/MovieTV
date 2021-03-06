//
//  MoviesCollectionViewCell.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/28/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol MoviesCollectionViewCellDelegate: AnyObject {
    func clickedMovie(for cell: UICollectionViewCell)
}

class MoviesCollectionViewCell: UICollectionViewCell, NibableCellProtocol {

    weak var delegate: MoviesCollectionViewCellDelegate?
    var data: MovieModel? {
        didSet {
            imgView.image = nil
            let imgURL = URLHelper.Image.customWidth(500, data?.posterPath).urlStr
            imgView.setImg(url: imgURL)
            titleLbl.text = data?.title
            
            let isVoteAverageInValid = data?.voteAverage == 0 || data?.voteAverage == nil
            
            ratingLbl.text = isVoteAverageInValid ? "N/A" : "\(data?.voteAverage ?? 0)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    
    @IBAction func clickedActionBtn(_ sender: Any) {
        print(superview?.convert(imgView.frame, to: nil), "justinbieber")
        delegate?.clickedMovie(for: self)
    }
    
    private func initial() {
        actionBtn.specificAnimateView = self
        layer.masksToBounds = false
        imgView.layer.cornerRadius = 42
        imgContainerView.layer.cornerRadius = 42
        imgContainerView.addAccentShadow()
    }

    @IBOutlet weak var imgContainerView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var actionBtn: MovieTVButton!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
}
