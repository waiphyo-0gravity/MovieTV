//
//  MovieTVTextField.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/14/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

@IBDesignable class MovieTVTextField: UIView {
    let txtField: UITextField = {
        let temp = UITextField()
        temp.font = UIFont.light_body_m
        temp.textColor = UIColor(named: "C100")
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    let placeHolder: UILabel = {
        let temp = PlaceHolder()
        temp.textColor = UIColor(named: "S70")
        temp.font = .light_body_l
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    let separatorView: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor(named: "S30")
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.heightAnchor.constraint(equalToConstant: 2).isActive = true
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
    
    @IBInspectable var isSecureEntry: Bool = false {
        didSet {
            txtField.isSecureTextEntry = isSecureEntry
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
    }
    
    private func animatePlaceHolderLbl(isMove: Bool) {
        UIView.easeSpringAnimation(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.9,
            options: [.curveEaseInOut]) {[weak self] in
            guard let self = self else { return }
            
            let placeHolderFrame = self.placeHolder.frame
            
            let translationY = -(placeHolderFrame.origin.y + placeHolderFrame.height / 2)
            let translationX = -(placeHolderFrame.width * 0.1) + 2.5
            
            let transform = CGAffineTransform.identity.translatedBy(x: translationX, y: translationY).concatenating(CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9))
            
            self.placeHolder.transform = isMove ? transform : .identity
            self.placeHolder.textColor = isMove ? UIColor(named: "C300") : UIColor(named: "S70")
            self.placeHolder.font = isMove ? UIFont.h4_strong?.withSize(20) : .light_body_l
        }
    }
}

//  MARK: - UI textfield delegates.

extension MovieTVTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField.text?.isEmpty != false else { return }
        
        animatePlaceHolderLbl(isMove: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField.text?.isEmpty != false else { return }
        
        animatePlaceHolderLbl(isMove: false)
    }
}

extension MovieTVTextField {
    private func addUIs() {
        guard !subviews.contains(txtField) else { return }
        
        addTxtField()
        addPlaceHolderLbl()
        addSeparator()
    }
    
    private func addTxtField() {
        addSubview(txtField)
        txtField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        txtField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        txtField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        txtField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        txtField.delegate = self
    }
    
    private func addPlaceHolderLbl() {
        addSubview(placeHolder)
        placeHolder.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        placeHolder.trailingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor).isActive = true
        placeHolder.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func addSeparator() {
        addSubview(separatorView)
        separatorView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
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
