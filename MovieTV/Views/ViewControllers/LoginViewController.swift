//
//  LoginViewController.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/15/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol LoginViewProtocol: AnyObject {
    var viewModel: LoginViewModelProtocol? { get set }
    
    func successLogin(data: CreateSessionModel)
    func failedLogin(error: Error?)
}

class LoginViewController: ViewController, UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
        animateViews(isShow: false, isAnimate: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateViews(isShow: true, isAnimate: true)
        handleInputFieldsChange(isAnimate: false)
    }
    
    @IBAction func clickLoginBtn(_ sender: Any) {
        makeLogin()
    }
    
    @objc private func handleKeyboard(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        switch notification.name {
        case UIResponder.keyboardWillShowNotification:
            view.frame.size.height = UIScreen.main.bounds.height - keyboardSize.height
        case UIResponder.keyboardWillHideNotification:
            view.frame.size.height = UIScreen.main.bounds.height
        default: break
        }
        
        view.layoutIfNeeded()
    }
    
    @objc private func handleTxtFieldChange(_ txtField: UITextField) {
        handleInputFieldsChange()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch true {
        case textField == userNameTxtField.txtField:
            passTxtField.txtField.becomeFirstResponder()
        case textField == passTxtField.txtField:
            makeLogin()
        default:
            break
        }
        
        return true
    }
    
//    MARK: - Varuables declaration.
    @IBOutlet weak var helloLbl: UILabel!
    @IBOutlet weak var userNameTxtField: MovieTVTextField!
    @IBOutlet weak var passTxtField: MovieTVTextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var loginBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginBtnContainerView: UIView!
    @IBOutlet weak var loginArrowImgView: UIImageView!
    
    var viewModel: LoginViewModelProtocol?
    
    enum ViewState {
        case normal, update
        
        var loginBtnWidth: CGFloat {
            switch self {
            case .normal:
                return 99
            case .update:
                return 64
            }
        }
        
        var loginBtnCornerRadius: CGFloat {
            switch self {
            case .normal:
                return 8
            case .update:
                return 32
            }
        }
    }
    
    private var currentViewState: ViewState = .normal {
        didSet {
            handleViewStateChange()
        }
    }
    
    let activityIndicator: UIActivityIndicatorView = {
        let temp = UIActivityIndicatorView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3)
        temp.color = .white
        return temp
    }()
}

//  MARK: - VIEW_MODEL -> VIEW
extension LoginViewController: LoginViewProtocol {
    func successLogin(data: CreateSessionModel) {
        viewModel?.routToMainView(from: self)
    }
    
    func failedLogin(error: Error?) {
        print(error)
    }
}

//  MARK: - Private functions.
extension LoginViewController {
    private func initial() {
        view.touchAroundToHideKeyboard()
        setUpHelloLabel()
        setUpLoginBtn()
        bindActions()
    }
    
    private func setUpLoginBtn() {
        loginBtnContainerView.layer.cornerRadius = 8
        
        loginArrowImgView.superview?.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: loginBtn.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: loginBtn.centerYAnchor).isActive = true
    }
    
    private func setUpHelloLabel() {
        guard let text = helloLbl.text else { return }
        
        let mutableText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont(name: UIFont.FontStyle.bold.rawValue, size: 42.0)!])
        mutableText.addAttribute(NSAttributedString.Key.font, value: UIFont(name: UIFont.FontStyle.regular.rawValue, size: 42)!, range: NSRange(location: 0, length: 5))
        helloLbl.attributedText = mutableText
    }
    
    private func bindActions() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        userNameTxtField.delegate = self
        userNameTxtField.txtField.returnKeyType = .next
        userNameTxtField.txtField.addTarget(self, action: #selector(handleTxtFieldChange(_:)), for: .editingChanged)
        
        passTxtField.delegate = self
        passTxtField.txtField.returnKeyType = .go
        passTxtField.txtField.addTarget(self, action: #selector(handleTxtFieldChange(_:)), for: .editingChanged)
    }
    
    private func makeLogin() {
        view.endEditing(true)
        
        currentViewState = .update
        
        viewModel?.logIn(username: userNameTxtField.txtField.text, password: passTxtField.txtField.text)
    }
    
//    MARK: - Animations.
    private func animateViews(isShow: Bool, isAnimate: Bool, complection: ((Bool)->Void)? = nil) {
        let duration: TimeInterval = 0.7
        var delaiedTime: TimeInterval = 0
        
        [helloLbl, welcomeLbl, userNameTxtField, passTxtField, footerView, loginBtn].enumerated().forEach { (index, element) in
            let delay: TimeInterval = Double(index) * 0.15
            let translationX: CGFloat
            let translationY: CGFloat
            
            delaiedTime += delay + duration
            
            switch true {
            case element == self.helloLbl, element == self.welcomeLbl:
                translationX = -40
                translationY = 0
            default:
                translationX = 0
                translationY = 40
            }
            
            UIView.easeSpringAnimation(isAnimate: isAnimate, withDuration: duration, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 0) {
                element?.transform = isShow ? .identity : CGAffineTransform(translationX: translationX, y: translationY)
                element?.alpha = isShow ? 1 : 0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delaiedTime) {
            complection?(true)
        }
    }
    
    private func handleInputFieldsChange(isAnimate: Bool = true) {
        let isNeedToEnable = userNameTxtField.txtField.text?.isEmpty == false && passTxtField.txtField.text?.isEmpty == false
        
        loginBtn.isUserInteractionEnabled = isNeedToEnable
        
        UIView.easeSpringAnimation(isAnimate: isAnimate) {[weak self] in
            self?.loginBtnContainerView.alpha = isNeedToEnable ? 1 : 0
            self?.loginBtnContainerView.transform = isNeedToEnable ? .identity : CGAffineTransform.identity.translatedBy(x: 0, y: 24)
        }
    }
    
    private func handleViewStateChange() {
        let isUpdating = currentViewState == .update
        
        UIView.easeSpringAnimation {[weak self] in
            guard let self = self else { return }
            
            self.loginBtnContainerView.layer.cornerRadius = self.currentViewState.loginBtnCornerRadius
            self.loginBtnWidthConstraint.constant = self.currentViewState.loginBtnWidth
            self.loginArrowImgView.alpha = isUpdating ? 0 : 1
            self.view.layoutIfNeeded()
        }
        
        loginBtn.isUserInteractionEnabled = !isUpdating
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0.0
        animation.toValue = CGFloat.pi / 2
        animation.duration = 0.5
        loginArrowImgView.layer.add(animation, forKey: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {[weak self, isUpdating] in
            if isUpdating == true {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}
