//
//  ProfileChooserCollectionViewCell.swift
//  MovieTV
//
//  Created by ZeroGravity on 3/24/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit
import Lottie

protocol ProfileChooserCollectionViewCellDelegates: AnyObject {
    func handleClickedProfile(for cell: UICollectionViewCell)
}

class ProfileChooserCollectionViewCell: UICollectionViewCell, NibableCellProtocol {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = false
        profileLottieView.loopMode = .loop
        profileContainerView.layer.shouldRasterize = true
        profileContainerView.layer.rasterizationScale = UIScreen.main.scale
        profileActionBtn.specificAnimateView = profileContainerView
    }
    
    @IBAction func clickedProfileActionBtn(_ sender: Any) {
        delegate?.handleClickedProfile(for: self)
    }
    
    private func handleDataChanged() {
        guard let data = data else { return }
        
        nameLbl.text = data.profile.name
        
        if let transformData = data.transform {
            profileContainerView.transform = transformData
        }
        
        profileLottieView.changeAnimation(with: data.profile.rawValue)
    }
    
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var profileLottieView: AnimationView!
    @IBOutlet weak var profileActionBtn: MovieTVButton!
    @IBOutlet weak var nameLbl: UILabel!
    
    weak var delegate: ProfileChooserCollectionViewCellDelegates?
    
    var data: ProfileChooserModel? {
        didSet {
            handleDataChanged()
        }
    }
}
