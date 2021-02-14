//
//  AuthenticationWebService.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/13/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import Foundation
import NetworkingFramework

protocol AuthenticationWebServiceInputProtocol {
    var viewModel: AuthenticationWebServiceOutPutProtocol? { get set }
    var apiKey: String? { get }
    
    func getRequestToken()
    func getRequestTokenWithLogin(bodyParameters: [String: Any])
    func createSession(bodyParameters: [String: Any])
}

protocol AuthenticationWebServiceOutPutProtocol: AnyObject {
    func responseFromRequestToken(isSuccess: Bool, data: RequestTokenModel?, error: Error?)
    func responseFromRequestTokenWithLogin(isSuccess: Bool, data: RequestTokenModel?, error: Error?)
    func responseFromCreateSession(isSuccess: Bool, data: CreateSessionModel?, error: Error?)
}

class AuthenticationWebService: AuthenticationWebServiceInputProtocol {
    weak var viewModel: AuthenticationWebServiceOutPutProtocol?
    
    var apiKey: String? {
        return UserDefaultsHelper.shared.apiKey
    }
    
    func getRequestToken() {
        guard let url = URLHelper.Authentication.requestToken.url else { return }
        
        NetworkingFramework.request(url: url, method: .get, urlQueries: [URLQueryItem(name: "api_key", value: apiKey)])
            .response(dataType: RequestTokenModel.self) {[weak self] (data, response, error) in
                guard let self = self else { return }
                
                guard let data = data else {
                    self.viewModel?.responseFromRequestToken(isSuccess: false, data: nil, error: error)
                    return
                }
                
                self.viewModel?.responseFromRequestToken(isSuccess: true, data: data, error: error)
            }
    }
    
    func getRequestTokenWithLogin(bodyParameters: [String : Any]) {
        guard let url = URLHelper.Authentication.requestTokenWithLogin.url else { return }
        NetworkingFramework.request(
            url: url,
            method: .post,
            urlQueries: [URLQueryItem(name: "api_key", value: apiKey)],
            bodyParameters: bodyParameters
        )
        .response(dataType: RequestTokenModel.self) {[weak self] (data, response, error) in
            guard let data = data else {
                self?.viewModel?.responseFromRequestTokenWithLogin(isSuccess: false, data: nil, error: error)
                return
            }
            
            self?.viewModel?.responseFromRequestTokenWithLogin(isSuccess: true, data: data, error: error)
        }
    }
    
    func createSession(bodyParameters: [String: Any]) {
        guard let url = URLHelper.Authentication.createSession.url else { return }
        NetworkingFramework.request(
            url: url,
            method: .post,
            urlQueries: [URLQueryItem(name: "api_key", value: apiKey)],
            bodyParameters: bodyParameters
        )
        .response(dataType: CreateSessionModel.self) {[weak self] (data, response, error) in
            guard let data = data else {
                self?.viewModel?.responseFromCreateSession(isSuccess: false, data: nil, error: error)
                return
            }
            
            self?.viewModel?.responseFromCreateSession(isSuccess: true, data: data, error: error)
        }
    }
}
