//
//  MovieTVButton.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/20/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

class MovieTVButton: UIButton {
    var delay: TimeInterval = 0.05
    weak var specificAnimateView: AnyObject?
    var scaleAnimateRatio: CGFloat = 0.9
    var originalTransform: CGAffineTransform = .identity
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configure() {
        addTarget(self, action: #selector(handleTouchDown), for: .touchDown)
        addTarget(self, action: #selector(handleTouchUpIndside), for: .touchUpInside)
        addTarget(self, action: #selector(handleTouchEnd), for: .touchUpOutside)
        addTarget(self, action: #selector(handleTouchEnd), for: .touchCancel)
        addTarget(self, action: #selector(handleTouchEnd), for: .touchDragExit)
    }
    
    @objc private func handleTouchDown() {
        animateViews(isPressed: true, event: .touchDown)
    }
    
    @objc private func handleTouchUpIndside() {
        UISelectionFeedbackGenerator().selectionChanged()
        animateViews(isPressed: false, event: .touchUpInside)
    }
    
    @objc private func handleTouchEnd() {
        animateViews(isPressed: false, event: .touchCancel)
    }
    
    private func animateViews(isPressed: Bool, event: UIControl.Event? = nil) {
        UIView.easeSpringAnimation(withDuration: 0.25, delay: isPressed ? 0 : delay) {[weak self] in
            guard let specificView: Any? = self?.specificAnimateView as? UIView ?? (self?.specificAnimateView as? [UIView] ?? self) else { return }

            if let specificView = specificView as? UIView {
                self?.animation(isPressed: isPressed, view: specificView, event: event)
            } else if let specificView = specificView as? [UIView] {
                specificView.forEach { view in
                    self?.animation(isPressed: isPressed, view: view, event: event)
                }
            }
        }
    }
    
    private func animation(isPressed: Bool, view: UIView, event: UIControl.Event? = nil) {
        if isPressed {
            view.transform = CGAffineTransform(scaleX: self.scaleAnimateRatio, y: self.scaleAnimateRatio)
            return
        }
        
        view.transform = event == .touchCancel ? originalTransform : .identity
    }
}
