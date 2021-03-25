//
//  LoginViewModel.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/15/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit
import AuthenticationServices
import SafariServices

protocol LoginViewModelProtocol {
    var view: LoginViewProtocol? { get set }
    var webService: AuthenticationWebServiceInputProtocol? { get set }
    var mainViewController: UIViewController? { get }
    var sessionID: String? { get set }
    var guestSessionID: String? { get set }
    var userType: String? { get set }
    var avatarName: String? { get set }
    
    func routToMainView(from view: UIViewController?)
    func logIn(username: String?, password: String?)
    func logInWithOAuth()
    func loginAsGuest()
    func setDefaultAvatarProfile()
}

class LoginViewModel: LoginViewModelProtocol {
    func logIn(username: String?, password: String?) {
        self.username = username
        self.password = password
        
        authenticationType = .normal
        webService?.getRequestToken()
    }
    
    func logInWithOAuth() {
        authenticationType = .OAuth
        webService?.getRequestToken()
    }
    
    func loginAsGuest() {
        authenticationType = .guest
        
        guard guestSessionID == nil else {
            userType = authenticationType.userType.rawValue
            view?.successLogin()
            return
        }
        
        webService?.createGuestSession()
    }
    
    func routToMainView(from view: UIViewController?) {
        guard let mainVC = mainViewController as? ViewController else { return }
        
        (view as? ViewController)?.transition(isShow: false, isAnimate: true, completion: {_ in
            UIApplication.shared.firstKeyWindow?.rootViewController = mainVC
            UIApplication.shared.firstKeyWindow?.makeKeyAndVisible()
        })
    }
    
    func setDefaultAvatarProfile() {
        guard avatarName == nil else { return }
        
        avatarName = ProfileChooserViewModel.ProfileData.makeRandom()?.rawValue
    }
    
    static func createModule() -> UIViewController? {
        guard let viewController = UIViewController.LoginViewController as? LoginViewController else { return nil }
        
        var viewModel: LoginViewModelProtocol & AuthenticationWebServiceOutPutProtocol = LoginViewModel()
        var webService: AuthenticationWebServiceInputProtocol = AuthenticationWebService()
        
        viewController.viewModel = viewModel
        viewModel.view = viewController
        viewModel.webService = webService
        webService.viewModel = viewModel
        
        return viewController
    }
    
    enum AuthenticationType {
        case normal, OAuth, guest
        
        var userType: UserDefaultsHelper.UserType {
            switch self {
            case .guest:
                return .guest
            default:
                return .normal
            }
        }
    }
    
    weak var view: LoginViewProtocol?
    var webService: AuthenticationWebServiceInputProtocol?
    
    var mainViewController: UIViewController? { MainContainerViewModel.createModule() }
    
    var sessionID: String? {
        get {
            return UserDefaultsHelper.shared.sessionID
        }
        
        set {
            UserDefaultsHelper.shared.sessionID = newValue
        }
    }
    
    var guestSessionID: String? {
        get {
            return UserDefaultsHelper.shared.guestSessionID
        }
        
        set {
            UserDefaultsHelper.shared.guestSessionID = newValue
        }
    }
    
    var userType: String? {
        get {
            return UserDefaultsHelper.shared.userType
        }
        
        set {
            UserDefaultsHelper.shared.userType = newValue
        }
    }
    
    var avatarName: String? {
        get {
            return UserDefaultsHelper.shared.avatarName
        }
        
        set {
            UserDefaultsHelper.shared.avatarName = newValue
        }
    }
    
    private var username: String?
    private var password: String?
    private var authenticationType: AuthenticationType = .normal
    
    private var authSession: AnyObject?
}

//  MARK: - Authentication process.
extension LoginViewModel {
    private func handleRequestTokenSuccess(with data: RequestTokenModel) {
        switch authenticationType {
        case .normal:
            guard let username = username,
                  let password = password else { return }
            
            webService?.getRequestTokenWithLogin(bodyParameters: [
                "username": username,
                "password": password,
                "request_token": data.requestToken
            ])
        case .OAuth:
            makeOAuthLogin(wit: data.requestToken)
        default:
            break
        }
    }
    
    private func makeOAuthLogin(wit token: String) {
        guard let url = URLHelper.Authentication.OAuthLogin(token: token).url else { return }
        
        if #available(iOS 12.0, *) {
            let asSuthSession = ASWebAuthenticationSession(url: url, callbackURLScheme: URLHelper.OAuthCallbackURLScheme, completionHandler: handleOAuthLoginComplection(_:_:))
            
            self.authSession = asSuthSession
            
            if #available(iOS 13.0, *) {
                asSuthSession.presentationContextProvider = view as? ASWebAuthenticationPresentationContextProviding
            }
            
            asSuthSession.start()
        } else {
            let sfAuthSession = SFAuthenticationSession(url: url, callbackURLScheme: URLHelper.OAuthCallbackURLScheme, completionHandler: handleOAuthLoginComplection(_:_:))
            
            self.authSession = sfAuthSession
            
            sfAuthSession.start()
        }
    }
    
    private func handleOAuthLoginComplection(_ url: URL?, _ error: Error?) {
        authSession = nil
        
        guard let url = url else {
            view?.failedLogin(error: error)
            return
        }
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        guard let requestToken = urlComponents?.queryItems?.first(where: { $0.name ==  "request_token" })?.value else { return }
        
        webService?.createSession(bodyParameters: [
            "request_token": requestToken
        ])
    }
}

//  MARK: - WERVICE -> VIEW_MODEL
extension LoginViewModel: AuthenticationWebServiceOutPutProtocol {
    func responseFromRequestToken(isSuccess: Bool, data: RequestTokenModel?, error: Error?) {
        if isSuccess,
           let data = data {
            handleRequestTokenSuccess(with: data)
        } else {
            view?.failedLogin(error: error)
        }
    }
    
    func responseFromCreateSession(isSuccess: Bool, data: CreateSessionModel?, error: Error?) {
        if isSuccess,
           let data = data {
            sessionID = data.sessionID
            userType = authenticationType.userType.rawValue
            
            view?.successLogin()
        } else {
            view?.failedLogin(error: error)
        }
    }
    
    func responseFromRequestTokenWithLogin(isSuccess: Bool, data: RequestTokenModel?, error: Error?) {
        if isSuccess,
           let data = data {
            webService?.createSession(bodyParameters: [
                "request_token": data.requestToken
            ])
        } else {
            view?.failedLogin(error: error)
        }
    }
    
    func responseFromCreateGuestSession(isSuccess: Bool, data: CreateGuestSessionModel?, error: Error?) {
        if isSuccess,
           let data = data {
            userType = authenticationType.userType.rawValue
            guestSessionID = data.guestSessionID
            
            view?.successLogin()
        } else {
            view?.failedLogin(error: error)
        }
    }
}
