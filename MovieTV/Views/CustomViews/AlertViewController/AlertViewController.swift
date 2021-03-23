//
//  AlertViewController.swift
//  MovieTV
//
//  Created by ZeroGravity on 3/7/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    convenience init(title: String?, body: String?, alertViewType: AlerViewType, actionHandler: (()->Void)? = nil) {
        self.init()
        titleTxt = title
        bodyTxt = body
        self.alertViewType = alertViewType
        self.actionHandler = actionHandler
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    override func loadView() {
        super.loadView()
        setUpViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateView(isShow: true)
    }
    
    @objc func handleClickedActionBtn(_ sender: UIButton) {
        dismissView {
            self.actions[sender.tag].handler?()
        }
    }
    
    @objc func handleTapedView(_ sender: UITapGestureRecognizer) {
        dismissView()
    }
    
    func addAction(_ action: AlertAction) {
        actions.append(action)
    }
    
    private func setUpViews() {
        view.addSubview(overlayView)
        overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        overlayView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(containerView)
        containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true

        switch alertViewType {
        case .bottom:
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        case .center:
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }

        containerView.addSubview(titleLbl)
        titleLbl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24).isActive = true
        titleLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24).isActive = true
        titleLbl.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24).isActive = true

        containerView.addSubview(bodyLbl)
        bodyLbl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24).isActive = true
        bodyLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24).isActive = true
        bodyLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 16).isActive = true

        containerView.addSubview(actionStackView)
        actionStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24).isActive = true
        actionStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24).isActive = true
        actionStackView.topAnchor.constraint(equalTo: bodyLbl.bottomAnchor, constant: 24).isActive = true
        actionStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24).isActive = true
    }
    
    private func initial() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapedView(_:)))
        view.addGestureRecognizer(tapGesture)
        
        containerView.layer.cornerRadius = 32
        setUpLabels()
        setUpBtn()
        animateView(isShow: false, isAnimate: false)
    }
    
    private func setUpLabels() {
        titleLbl.text = titleTxt
        bodyLbl.text = bodyTxt
    }
    
    private func setUpBtn() {
        actionStackView.subviews.forEach({ $0.removeFromSuperview() })
        
        actions.enumerated().forEach { action in
            let button = MovieTVButton()
            button.setTitleColor(action.element.type.btnTxtColor, for: .normal)
            button.setTitle(action.element.title, for: .normal)
            button.titleLabel?.font = UIFont(name: UIFont.FontStyle.bold.rawValue, size: 17)
            button.backgroundColor = action.element.type.btnBackgroundColor
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 48).isActive = true
            button.layer.cornerRadius = 12
            button.addTarget(self, action: #selector(handleClickedActionBtn(_:)), for: .touchUpInside)
            button.tag = action.offset
            
            actionStackView.addArrangedSubview(button)
        }
    }
    
    private func dismissView(completion: (()->Void)? = nil) {
        animateView(isShow: false) {_ in
            self.dismiss(animated: false, completion: completion)
        }
    }
    
    private func animateView(isShow: Bool, isAnimate: Bool = true, completion: ((Bool)->Void)? = nil) {
        view.layoutIfNeeded()
        
        switch alertViewType {
        case .bottom:
            UIView.easeSpringAnimation(isAnimate: isAnimate, animations: {
                self.overlayView.alpha = isShow ? 1 : 0
                self.containerView.transform = isShow ? .identity : .init(translationX: 0, y: self.containerView.frame.height + self.view.safeAreaInsets.bottom)
            }, completion: completion)
        case .center:
            UIView.easeSpringAnimation(isAnimate: isAnimate, delay: isShow ? 0 : 0.25, animations: {
                self.overlayView.alpha = isShow ? 1 : 0
            })
            
            if isShow {
                containerView.bouncePopUpAnimation(isAnimate: isAnimate, completion: completion)
            } else {
                containerView.bouncePopDownAnimation(isAnimate: isAnimate, completion: completion)
            }
        }
    }
    
    let overlayView: UIVisualEffectView = {
        let temp = UIVisualEffectView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        return temp
    }()

    let containerView: UIView = {
        let temp = UIView()
        temp.backgroundColor = .white
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    let titleLbl: UILabel = {
        let temp = UILabel()
        temp.font = UIFont(name: UIFont.FontStyle.bold.rawValue, size: 20)
        temp.textColor = .C300
        temp.numberOfLines = 0
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    let bodyLbl: UILabel = {
        let temp = UILabel()
        temp.font = UIFont(name: UIFont.FontStyle.regular.rawValue, size: 17)
        temp.textColor = .C100
        temp.numberOfLines = 0
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    let actionStackView: UIStackView = {
        let temp = UIStackView()
        temp.axis = .vertical
        temp.distribution = .fillEqually
        temp.spacing = 16
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    var titleTxt: String?
    var bodyTxt: String?
    var actionHandler: (()->Void)?
    
    private var alertViewType: AlerViewType = .bottom
    private var actions = [AlertAction]()
    
    enum AlerViewType {
        case bottom, center
    }
}

struct AlertAction {
    let title: String?
    let type: AlertType
    var handler: (()->Void)? = nil
    
    enum AlertType {
        case `default`, destructive, cancel, custom(bgColor: UIColor?, txtColor: UIColor?)
        
        var btnBackgroundColor: UIColor? {
            switch self {
            case .default:
                return UIColor(named: "B100")
            case .destructive:
                return UIColor(named: "R100")
            case .cancel:
                return UIColor(named: "S10")
            case .custom(let bgColor, _):
                return bgColor
            }
        }
        
        var btnTxtColor: UIColor? {
            switch self {
            case .default, .destructive:
                return UIColor.white
            case .cancel:
                return UIColor(named: "C300")
            case .custom(_ , let txtColor):
                return txtColor
            }
        }
    }
}
