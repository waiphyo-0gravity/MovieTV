//
//  SearchWebService.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/24/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import Foundation
import NetworkingFramework

protocol SearchWebServiceInputProtocol {
    var viewModel: SearchWebServiceOutputProtocol? { get set }
    var apiKey: String? { get }
    var searchReq: URLSessionDataTask? { get }
    
    func searchMovie(with keyword: String, page: Int, includeAdult: Bool)
}

protocol SearchWebServiceOutputProtocol: AnyObject {
    func responseFromSearchMovie(isSuccess: Bool, data: MovieListModel?, error: Error?)
}

class SearchWebService: SearchWebServiceInputProtocol {
    func searchMovie(with keyword: String, page: Int, includeAdult: Bool) {
        guard let url = URLHelper.Search.searchMovie.url else { return }
        
        searchReq?.cancel()
        
        searchReq = NetworkingFramework.request(
            url: url,
            method: .get,
            urlQueries: [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "include_adult", value: includeAdult ? "true" : "false"),
                URLQueryItem(name: "query", value: keyword),
                URLQueryItem(name: "page", value: "\(page)")
            ], bodyParameters: nil)
            .response(dataType: MovieListModel.self, complection: {[weak self] (data, response, error) in
                
                guard let data = data else {
                    self?.viewModel?.responseFromSearchMovie(isSuccess: false, data: nil, error: error)
                    return
                }
                
                self?.viewModel?.responseFromSearchMovie(isSuccess: true, data: data, error: error)
            })
    }
    
    weak var viewModel: SearchWebServiceOutputProtocol?
    var apiKey: String? { URLHelper.apiKey }
    
    private(set)var searchReq: URLSessionDataTask?
}
