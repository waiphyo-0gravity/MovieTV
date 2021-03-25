//
//  LoginViewController.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/15/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit
import AuthenticationServices
import Lottie

protocol LoginViewProtocol: AnyObject {
    var viewModel: LoginViewModelProtocol? { get set }
    
    func successLogin()
    func failedLogin(error: Error?)
}

class LoginViewController: ViewController, UITextFieldDelegate {
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
        transition(isShow: false, isAnimate: false)
        handleViewStateChange()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        transition(isShow: true, isAnimate: true)
        handleInputFieldsChange(isAnimate: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func transition(isShow: Bool, isAnimate: Bool, completion: ((Bool) -> Void)? = nil) {
        greetingLottieView.layoutIfNeeded()
        
        UIView.easeSpringAnimation(isAnimate: isAnimate, withDuration: 0.3, animations: {[weak self] in
            self?.topView.alpha = isShow ? 1 : 0
            self?.stackView.alpha = isShow ? 1 : 0
            self?.footerView.alpha = isShow ? 1 : 0
            self?.loginBtnContainerView.alpha = isShow ? 1 : 0
            self?.footerView.transform = isShow ? .identity : .init(translationX: 0, y: 40)
            self?.stackView.transform = isShow ? .identity : .init(translationX: -40, y: 0)
            self?.loginBtnContainerView.transform = isShow ? .identity : .init(translationX: 0, y: 40)
            
            if self?.viewState == .loading {
                self?.loadingLottieView.alpha = isShow ? 1 : 0
            } else {
                self?.greetingLottieView.alpha = isShow ? 1 : 0
                self?.greetingLottieView.transform = isShow ? .identity : .init(translationX: 40, y: 0)
            }
        }, completion: completion)
    }
    
    @IBAction func clickLoginBtn(_ sender: Any) {
        viewState = .loading
        makeLogin()
    }
    
    @IBAction func clickLoginWithTMDbBtn(_ sender: Any) {
        view.endEditing(true)
        viewState = .loading
        viewModel?.logInWithOAuth()
    }
    
    @IBAction func clickGuestBtn(_ sender: Any) {
        view.endEditing(true)
        viewState = .loading
        viewModel?.loginAsGuest()
    }
    
    @objc private func willEnterForeground() {
        if viewState == .loading {
            loadingLottieView.play()
        } else {
            greetingLottieView.play()
        }
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
    @IBOutlet weak var userNameTxtField: MovieTVTextField!
    @IBOutlet weak var passTxtField: MovieTVTextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var loginBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginBtnContainerView: UIView!
    @IBOutlet weak var loginArrowImgView: UIImageView!
    @IBOutlet weak var loginWithTMDbBtnContainerView: UIView!
    @IBOutlet weak var orSeparatorLbl: UILabel!
    @IBOutlet weak var loginWithTMDbActionBtn: MovieTVButton!
    @IBOutlet weak var guestBtn: MovieTVButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var greetingLottieView: AnimationView!
    @IBOutlet weak var loadingLottieView: AnimationView!
    
    var viewModel: LoginViewModelProtocol?
    
    enum LoginBtnState {
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
    
    enum ViewState {
        case normal, loading, fail
    }
    
    private var loginBtnState: LoginBtnState = .normal {
        didSet {
            guard oldValue != loginBtnState else { return }
            
            handleLoginBtnStateChange()
        }
    }
    
    private var viewState: ViewState = .normal {
        didSet {
            guard oldValue != viewState else { return }
            
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
    @available(iOS 12.0, *)
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
}

//  MARK: - VIEW_MODEL -> VIEW
extension LoginViewController: LoginViewProtocol {
    func successLogin() {
        viewModel?.setDefaultAvatarProfile()
        viewModel?.routToMainView(from: self)
    }
    
    func failedLogin(error: Error?) {
        viewState = .normal
        loginBtnState = .normal
    }
}

//  MARK: - Private functions.
extension LoginViewController {
    private func initial() {
        view.touchAroundToHideKeyboard()
        setUpLoginBtn()
        setUpOAuthBtn()
        setUpGuestBtn()
        bindActions()
        greetingLottieView.loopMode = .loop
        loadingLottieView.loopMode = .loop
    }
    
    private func setUpLoginBtn() {
        loginBtnContainerView.layer.cornerRadius = 8
        
        loginArrowImgView.superview?.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: loginBtn.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: loginBtn.centerYAnchor).isActive = true
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
        userNameTxtField.txtField.resignFirstResponder()
        passTxtField.txtField.resignFirstResponder()
        loginBtnState = .update
        
        viewModel?.logIn(username: userNameTxtField.txtField.text, password: passTxtField.txtField.text)
    }
    
//    MARK: - Animations.
    private func handleInputFieldsChange(isAnimate: Bool = true) {
        let isNeedToEnable = userNameTxtField.txtField.text?.isEmpty == false && passTxtField.txtField.text?.isEmpty == false
        
        loginBtn.isUserInteractionEnabled = isNeedToEnable
        
        UIView.easeSpringAnimation(isAnimate: isAnimate) {[weak self] in
            self?.loginBtnContainerView.backgroundColor = isNeedToEnable ? UIColor.Secondary100 : UIColor.S70
            self?.loginBtnContainerView.transform = isNeedToEnable ? .identity : CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
        }
    }
    
    private func handleLoginBtnStateChange() {
        let isUpdating = loginBtnState == .update
        
        UIView.easeSpringAnimation {[weak self] in
            guard let self = self else { return }
            
            self.loginBtnContainerView.layer.cornerRadius = self.loginBtnState.loginBtnCornerRadius
            self.loginBtnWidthConstraint.constant = self.loginBtnState.loginBtnWidth
            self.loginArrowImgView.alpha = isUpdating ? 0 : 1
            self.view.layoutIfNeeded()
        }
        
        loginBtn.isUserInteractionEnabled = !isUpdating
        
        if isUpdating {
            let animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.fromValue = 0.0
            animation.toValue = CGFloat.pi / 2
            animation.duration = 0.5
            loginArrowImgView.layer.add(animation, forKey: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {[weak self, isUpdating] in
            if isUpdating == true {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func handleViewStateChange() {
        let isLoading = viewState == .loading
        
        greetingLottieView.alpha = isLoading ? 0 : 1
        loadingLottieView.alpha = isLoading ? 1 : 0
        view.isUserInteractionEnabled = !isLoading
        
        UIView.easeSpringAnimation {
            self.stackView.alpha = isLoading ? 0.5 : 1
            self.footerView.alpha = isLoading ? 0.5 : 1
            self.loginBtnContainerView.alpha = isLoading ? 0.5 : 1
        }
        
        switch viewState {
        case .normal, .fail:
            greetingLottieView.play()
            
            loadingLottieView.stop()
            loadingLottieView.layer.removeAllAnimations()
            loadingLottieView.transform = .identity
        case .loading:
            greetingLottieView.stop()
            
            loadingLottieView.play()
            
            let groupAnimation = CAAnimationGroup()
            groupAnimation.duration = 6
            groupAnimation.repeatCount = .infinity
            
            let translationAnimation = CABasicAnimation(keyPath: "transform.translation.x")
            translationAnimation.duration = 3
            translationAnimation.autoreverses = true
            translationAnimation.fromValue = 0
            translationAnimation.fillMode = .both
            translationAnimation.toValue = -UIScreen.main.bounds.width/2
            
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
            rotationAnimation.duration = 0.0001
            rotationAnimation.beginTime = 3
            rotationAnimation.fromValue = 0
            rotationAnimation.fillMode = .both
            rotationAnimation.isRemovedOnCompletion = false
            rotationAnimation.toValue = CGFloat.pi
            
            groupAnimation.animations = [translationAnimation, rotationAnimation]
            
            loadingLottieView.layer.add(groupAnimation, forKey: "move")
        }
    }
}
