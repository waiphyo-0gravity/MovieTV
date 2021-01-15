//
//  MovieTVTextField.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/14/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

@IBDesignable class MovieTVTextField: UIView {
    lazy var txtField: UITextField = {
        let temp = UITextField()
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    lazy var placeHolder: UILabel = {
        let temp = PlaceHolder()
        temp.textColor = UIColor(red: 0.693, green: 0.696, blue: 0.7, alpha: 1)
        temp.font = .light_body_l
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    @IBInspectable var placeHolderTxt: String? {
        didSet {
            placeHolder.text = placeHolderTxt
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        didSet {
            placeHolder.textColor = placeHolderColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Initial()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Initial()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        Initial()
    }
    
    private func Initial() {
        addUIs()
        backgroundColor = .systemYellow
    }
}

extension MovieTVTextField {
    private func addUIs() {
        guard !subviews.contains(txtField) else { return }
        
        addTxtField()
        addPlaceHolderLbl()
    }
    
    private func addTxtField() {
        addSubview(txtField)
        txtField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        txtField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        txtField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        txtField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func addPlaceHolderLbl() {
        addSubview(placeHolder)
        placeHolder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        placeHolder.trailingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: -16).isActive = true
        placeHolder.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    class PlaceHolder: UILabel {
        private let padding: CGFloat = 5
        
        override func awakeFromNib() {
            super.awakeFromNib()
            initial()
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            initial()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            createShadowPath()
        }
        
        private func initial() {
            layer.shadowOffset = .init(width: -padding, height: 0)
            layer.shadowRadius = 0
            layer.shadowColor = UIColor.white.cgColor
            layer.shadowOpacity = 1
            createShadowPath()
        }
        
        private func createShadowPath() {
            let path = UIBezierPath(rect: .init(origin: .zero, size: .init(width: frame.width + (padding * 2), height: frame.height)))
            layer.shadowPath = path.cgPath
        }
    }
}
