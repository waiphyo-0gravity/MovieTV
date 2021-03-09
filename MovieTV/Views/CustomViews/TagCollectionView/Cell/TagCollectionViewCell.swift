//
//  TagCollectionViewCell.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/27/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol TagCollectionViewCellDelegate: AnyObject {
    func handleTagSelection(for cell: UICollectionViewCell)
}

class TagCollectionViewCell: UICollectionViewCell, NibableCellProtocol {

    static let tagNameFont: UIFont = UIFont.h4_strong!.withSize(16)
    
    let statusHorizontalShapeLayer: CAShapeLayer = {
        let shape = CAShapeLayer()
        let path = UIBezierPath(roundedRect: .init(x: 3, y: 7, width: 10, height: 2), cornerRadius: 1)
        shape.path = path.cgPath
        shape.frame = .init(x: 0, y: 0, width: 16, height: 16)
        shape.fillColor = UIColor(named: "C75")?.cgColor
        return shape
    }()
    
    let statusVerticalShapeLayer: CAShapeLayer = {
        let shape = CAShapeLayer()
        let path = UIBezierPath(roundedRect: .init(x: 7, y: 3, width: 2, height: 10), cornerRadius: 1)
        shape.path = path.cgPath
        shape.frame = .init(x: 0, y: 0, width: 16, height: 16)
        shape.fillColor = UIColor(named: "C75")?.cgColor
        return shape
    }()
    
    var data: GenreModel! {
        didSet {
            tagNameLbl.text = data.name
            
            setSelect(data.isSelected == true, isAnimate: false)
        }
    }
    
    weak var delegate: TagCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    
    private func initial() {
        clipsToBounds = false
        
        setUpTagView()
        setUpStatusSignView()
    }
    
    private func setUpTagView() {
        actionBtn.specificAnimateView = tagContainerView
        
        tagNameLbl.textColor = UIColor(named: "C75")
        tagNameLbl.font = Self.tagNameFont
        
        tagContainerView.layer.cornerRadius = 34 / 2
        tagContainerView.layer.borderWidth = 2
        tagContainerView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
    }
    
    private func setUpStatusSignView() {
        statusSignView.isUserInteractionEnabled = false
        statusSignView.layer.cornerRadius = 8
        statusSignView.layer.shadowPath = nil
        statusSignView.layer.shadowOffset = .zero
        statusSignView.layer.shadowRadius = 2
        statusSignView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        statusSignView.layer.shadowOpacity = 1
        
        statusSignView.layer.addSublayer(statusHorizontalShapeLayer)
        statusSignView.layer.addSublayer(statusVerticalShapeLayer)
    }
    
    @IBAction func clickedActionBtn(_ sender: Any) {
        handleClickedActionBtn()
    }
    
    private func handleClickedActionBtn() {
        delegate?.handleTagSelection(for: self)
        data?.isSelected.toggle()
        setSelect(data?.isSelected == true)
    }
    
    func setSelect(_ value: Bool, isAnimate: Bool = true) {
        let animation = {
            self.tagContainerView.backgroundColor = value ? UIColor(named: "C75") : .white
            self.tagNameLbl.textColor = value ? .white : UIColor(named: "C75")
        }
        
        animateStatusView(forSelection: value, isAnimate: isAnimate)
        
        guard isAnimate else {
            animation()
            return
        }
        
        UIView.transition(with: tagContainerView, duration: 0.3, options: .transitionCrossDissolve) {
            animation()
        }
    }
    
    private func animateStatusView(forSelection value: Bool, isAnimate: Bool) {
        statusVerticalShapeLayer.removeAllAnimations()
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.duration = isAnimate ? 0 : 0.3
        if isAnimate {
            anim.fromValue = value ? 0 : CGFloat.pi / 4
        }
        anim.toValue = value ? CGFloat.pi / 4 : 0
        anim.fillMode = .both
        anim.isRemovedOnCompletion = false
        statusSignView.layer.add(anim, forKey: "rotation")
        
        let colorChangeAnim = CABasicAnimation(keyPath: "fillColor")
        colorChangeAnim.duration = isAnimate ? 0 : 0.3
        if isAnimate {
            colorChangeAnim.fromValue = value ? UIColor(named: "C75")?.cgColor : UIColor(named: "R100")?.cgColor
        }
        colorChangeAnim.toValue = value ? UIColor(named: "R100")?.cgColor : UIColor(named: "C75")?.cgColor
        colorChangeAnim.isRemovedOnCompletion = false
        colorChangeAnim.fillMode = .forwards
        statusVerticalShapeLayer.add(colorChangeAnim, forKey: "colorChanging")
        statusHorizontalShapeLayer.add(colorChangeAnim, forKey: "colorChanging")
    }
    
    @IBOutlet weak var tagNameLbl: UILabel!
    @IBOutlet weak var tagContainerView: UIView!
    @IBOutlet weak var actionBtn: MovieTVButton!
    @IBOutlet weak var statusSignView: UIView!
}
