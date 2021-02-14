//
//  LoginViewModel.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/15/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol LoginViewModelProtocol {
    var view: LoginViewProtocol? { get set }
    var webService: AuthenticationWebServiceInputProtocol? { get set }
    var mainViewController: UIViewController? { get }
    var sessionID: String? { get set }
    
    func routToMainView(from view: UIViewController?)
    func logIn(username: String?, password: String?)
}

class LoginViewModel: LoginViewModelProtocol {
    weak var view: LoginViewProtocol?
    var webService: AuthenticationWebServiceInputProtocol?
    
    var mainViewController: UIViewController? { MainViewModel.createModule( isIncludeNavigation: true) }
    
    var sessionID: String? {
        get {
            return UserDefaultsHelper.shared.sessionID
        }
        
        set {
            UserDefaultsHelper.shared.sessionID = newValue
        }
    }
    
    private var username: String?
    private var password: String?
    
    func logIn(username: String?, password: String?) {
        self.username = username
        self.password = password
        
        webService?.getRequestToken()
    }
    
    func routToMainView(from view: UIViewController?) {
        guard let mainVC = mainViewController else { return }
        
        mainVC.modalPresentationStyle = .fullScreen
        view?.present(mainVC, animated: true)
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
}

//  MARK: - WERVICE -> VIEW_MODEL
extension LoginViewModel: AuthenticationWebServiceOutPutProtocol {
    func responseFromRequestToken(isSuccess: Bool, data: RequestTokenModel?, error: Error?) {
        if isSuccess,
           let data = data,
           let username = username,
           let password = password {
            webService?.getRequestTokenWithLogin(bodyParameters: [
                "username": username,
                "password": password,
                "request_token": data.requestToken
            ])
        } else {
            view?.failedLogin(error: error)
        }
    }
    
    func responseFromCreateSession(isSuccess: Bool, data: CreateSessionModel?, error: Error?) {
        if isSuccess,
           let data = data {
            sessionID = data.sessionID
            view?.successLogin(data: data)
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
}
