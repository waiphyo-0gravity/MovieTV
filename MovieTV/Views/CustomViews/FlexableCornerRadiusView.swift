//
//  FlexableCornerRadiusView.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/11/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

class FlexableCornerRadiusView: UIView {
    var cornerRadiusData: (corners: UIRectCorner, cornerRadius: CGFloat) = (.allCorners, 0) {
        didSet {
            changeCornerRadiusPath()
        }
    }
    
    let cornerRaduisMaskLayer: CAShapeLayer = {
        let temp = CAShapeLayer()
        temp.fillColor = UIColor.white.cgColor
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initial()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        changeCornerRadiusPath()
    }
    
    private func initial() {
        layer.mask = cornerRaduisMaskLayer
    }
    
    private func changeCornerRadiusPath() {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: cornerRadiusData.corners,
            cornerRadii: .init(width: cornerRadiusData.cornerRadius, height: cornerRadiusData.cornerRadius)
        )
        
        cornerRaduisMaskLayer.path = path.cgPath
    }
}

class FlexableCornerRadiusScrollView: UIScrollView {
    var cornerRadiusData: (corners: UIRectCorner, cornerRadius: CGFloat) = (.bottomLeft, 0) {
        didSet {
            changeCornerRadiusPath()
        }
    }
    
    let cornerRaduisMaskLayer: CAShapeLayer = {
        let temp = CAShapeLayer()
        temp.fillColor = UIColor.white.cgColor
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initial()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        changeCornerRadiusPath()
    }
    
    private func initial() {
        layer.mask = cornerRaduisMaskLayer
    }
    
    private func changeCornerRadiusPath() {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: cornerRadiusData.corners,
            cornerRadii: .init(width: cornerRadiusData.cornerRadius, height: cornerRadiusData.cornerRadius)
        )
        
        cornerRaduisMaskLayer.path = path.cgPath
    }
}

class FlexableCornerRadiusImgView: UIImageView {
    var cornerRadiusData: (corners: UIRectCorner, cornerRadius: CGFloat) = (.allCorners, 0) {
        didSet {
            changeCornerRadiusPath()
        }
    }
    
    private let cornerRaduisMaskLayer: CAShapeLayer = {
        let temp = CAShapeLayer()
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initial()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        changeCornerRadiusPath()
    }
    
    private func initial() {
        layer.mask = cornerRaduisMaskLayer
    }
    
    private func changeCornerRadiusPath() {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: cornerRadiusData.corners, cornerRadii: .init(width: cornerRadiusData.cornerRadius, height: cornerRadiusData.cornerRadius))
        cornerRaduisMaskLayer.path = path.cgPath
    }
}

class FlexableCornerRadiusCollectionView: UICollectionView {
    var cornerRadiusData: (corners: UIRectCorner, cornerRadius: CGFloat) = (.allCorners, 0) {
        didSet {
            changeCornerRadiusPath()
        }
    }
    
    private let cornerRaduisMaskLayer: CAShapeLayer = {
        let temp = CAShapeLayer()
        return temp
    }()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initial()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        changeCornerRadiusPath()
    }
    
    private func initial() {
        layer.mask = cornerRaduisMaskLayer
    }
    
    private func changeCornerRadiusPath() {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: cornerRadiusData.corners, cornerRadii: .init(width: cornerRadiusData.cornerRadius, height: cornerRadiusData.cornerRadius))
        cornerRaduisMaskLayer.path = path.cgPath
    }
}
