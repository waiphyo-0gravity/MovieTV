//
//  FilterCollectionViewCell.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/23/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol FilterCollectionViewCellDelegate: AnyObject {
    func handleCellSelection(for cell: UICollectionViewCell)
}

class FilterCollectionViewCell: UICollectionViewCell, NibableCellProtocol {
    
    static let nameLblFont = UIFont.h4_strong?.withSize(28)
    
    weak var delegate: FilterCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLbl.font = Self.nameLblFont
        actionBtn.specificAnimateView = nameLbl
    }
    
    @IBAction func clickedActionBtn(_ sender: Any) {
        setSelect(true)
        delegate?.handleCellSelection(for: self)
    }
    
    func setSelect(_ value: Bool, isAnimate: Bool = true) {
        let txtColor: UIColor? = value ? UIColor(named: "C100") : UIColor(named: "S70")
        
        guard txtColor != nameLbl.textColor else { return }
        
        guard isAnimate else {
            nameLbl.textColor = txtColor
            return
        }
        
        UIView.transition(with: nameLbl, duration: 0.3, options: .transitionCrossDissolve) {[weak self] in
            self?.nameLbl.textColor = txtColor
        }
    }
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var actionBtn: MovieTVButton!
}
