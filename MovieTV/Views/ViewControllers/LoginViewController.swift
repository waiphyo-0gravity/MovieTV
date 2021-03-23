//
//  LoginViewController.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/15/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit
import AuthenticationServices

protocol LoginViewProtocol: AnyObject {
    var viewModel: LoginViewModelProtocol? { get set }
    
    func successLogin()
    func failedLogin(error: Error?)
}

class LoginViewController: ViewController, UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
        transition(isShow: false, isAnimate: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        transition(isShow: true, isAnimate: true)
        handleInputFieldsChange(isAnimate: false)
    }
    
    override func transition(isShow: Bool, isAnimate: Bool, completion: ((Bool) -> Void)? = nil) {
        UIView.easeSpringAnimation(isAnimate: isAnimate, withDuration: 0.3, animations: {[weak self] in
            self?.topView.alpha = isShow ? 1 : 0
            self?.stackView.alpha = isShow ? 1 : 0
            self?.footerView.alpha = isShow ? 1 : 0
            self?.characterImgView.alpha = isShow ? 1 : 0
            self?.loginBtnContainerView.alpha = isShow ? 1 : 0
            self?.characterImgView.transform = isShow ? .identity : .init(translationX: 24, y: 0)
            self?.helloLbl.transform = isShow ? .identity : .init(translationX: 0, y: -24)
            self?.welcomeLbl.transform = isShow ? .identity : .init(translationX: -24, y: 0)
            self?.footerView.transform = isShow ? .identity : .init(translationX: 0, y: 40)
            self?.stackView.transform = isShow ? .identity : .init(translationX: 40, y: 0)
            self?.loginBtnContainerView.transform = isShow ? .identity : .init(translationX: 0, y: 40)
        }, completion: completion)
    }
    
    @IBAction func clickLoginBtn(_ sender: Any) {
        makeLogin()
    }
    
    @IBAction func clickLoginWithTMDbBtn(_ sender: Any) {
        view.endEditing(true)
        viewModel?.logInWithOAuth()
    }
    
    @IBAction func clickGuestBtn(_ sender: Any) {
        view.endEditing(true)
        viewModel?.loginAsGuest()
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
    @IBOutlet weak var loginWithTMDbBtnContainerView: UIView!
    @IBOutlet weak var orSeparatorLbl: UILabel!
    @IBOutlet weak var loginWithTMDbActionBtn: MovieTVButton!
    @IBOutlet weak var guestBtn: MovieTVButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var characterImgView: UIImageView!
    @IBOutlet weak var topView: UIView!
    
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

//  MARK: - ASWebAuthenticationSession
extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
}

//  MARK: - VIEW_MODEL -> VIEW
extension LoginViewController: LoginViewProtocol {
    func successLogin() {
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
        setUpOAuthBtn()
        setUpGuestBtn()
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
    
    private func setUpOAuthBtn() {
        loginWithTMDbActionBtn.specificAnimateView = loginWithTMDbBtnContainerView
        loginWithTMDbBtnContainerView.layer.cornerRadius = 12
        loginWithTMDbBtnContainerView.layer.borderWidth = 1
        loginWithTMDbBtnContainerView.layer.borderColor = UIColor.S30.cgColor
        loginWithTMDbBtnContainerView.addAccentShadow()
    }
    
    private func setUpGuestBtn() {
        let prefix = "Tour as "
        let postfix = "Guest"
        
        let mutableAttributedStr = NSMutableAttributedString(string: "\(prefix)\(postfix)?", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.C100,
            NSAttributedString.Key.font: UIFont(name: UIFont.FontStyle.regular.rawValue, size: 15)!
        ])
        
        let range = NSRange(location: prefix.count, length: postfix.count)
        
        mutableAttributedStr.addAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.B100
        ], range: range)
        
        guestBtn.setAttributedTitle(mutableAttributedStr, for: .normal)
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
    private func handleInputFieldsChange(isAnimate: Bool = true) {
        let isNeedToEnable = userNameTxtField.txtField.text?.isEmpty == false && passTxtField.txtField.text?.isEmpty == false
        
        loginBtn.isUserInteractionEnabled = isNeedToEnable
        
        UIView.easeSpringAnimation(isAnimate: isAnimate) {[weak self] in
            self?.loginBtnContainerView.backgroundColor = isNeedToEnable ? UIColor.systemOrange : UIColor.S70
            self?.loginBtnContainerView.transform = isNeedToEnable ? .identity : CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
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
