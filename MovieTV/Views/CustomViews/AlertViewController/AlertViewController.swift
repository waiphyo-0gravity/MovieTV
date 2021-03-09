//
//  AlertViewController.swift
//  MovieTV
//
//  Created by ZeroGravity on 3/7/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    convenience init(title: String?, body: String?, alertType: AlertType = .default, firstActionTitle: String?, secondActionTitle: String? = "Cancel", actionHandler: (()->Void)? = nil) {
        self.init()
        titleTxt = title
        bodyTxt = body
        self.firstActionTitle = firstActionTitle
        self.secondActionTitle = secondActionTitle
        self.alertType = alertType
        self.actionHandler = actionHandler
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
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
        UIView.easeSpringAnimation(isAnimate: isAnimate, animations: {
            self.overlayView.alpha = isShow ? 1 : 0
            self.containerView.transform = isShow ? .identity : .init(translationX: 0, y: self.containerView.frame.height + self.view.safeAreaInsets.bottom)
        }, completion: completion)
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var overlayView: UIVisualEffectView!
    @IBOutlet weak var actionStackView: UIStackView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bodyLbl: UILabel!
    
    var titleTxt: String?
    var bodyTxt: String?
    var firstActionTitle: String?
    var secondActionTitle: String?
    var actionHandler: (()->Void)?
    
    private var alertType: AlertType = .default
    private var actions = [AlertAction]()
    
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

struct AlertAction {
    let title: String?
    let type: AlertViewController.AlertType
    var handler: (()->Void)? = nil
}
