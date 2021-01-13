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
    func getRequestToken()
}

protocol AuthenticationWebServiceOutPutProtocol: AnyObject {
    
}

class AuthenticationWebService: AuthenticationWebServiceInputProtocol {
    weak var viewModel: AuthenticationWebServiceOutPutProtocol?
    
    func getRequestToken() {
        guard let url = URLHelper.requestToken.url else { return }
        
        let req = NetworkingFramework.request(url: url, method: .get, bodyParameters: [URLQueryItem(name: "api_key", value: UserDefaultsHelper.shared.apiKey)])
            .response(dataType: RequestTokenModel.self) {[weak self] (data, response, error) in
                guard let self = self else { return }
                
                print(data, response?.statusCode, error)
            }
        
        print(req.debugDescription)
        
    }
}
