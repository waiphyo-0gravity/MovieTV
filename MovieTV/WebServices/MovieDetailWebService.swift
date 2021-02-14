//
//  MovieDetailWebService.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/14/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import Foundation
import NetworkingFramework

protocol MovieDetailWebServiceInputProtocol {
    var viewModel: MovieDetailWebServiceOutputProtocol? { get set }
    var apiKey: String? { get }
    
    func getMovieDetail(for movieID: Int)
}

protocol MovieDetailWebServiceOutputProtocol: AnyObject {
    func responseFromMovieDetail(isSuccess: Bool, data: MovieDetailModel?, error: Error?)
}

//  MARK: - Declare optional functions.
extension MovieDetailWebServiceOutputProtocol {
}

class MovieDetailWebService: MovieDetailWebServiceInputProtocol {
    func getMovieDetail(for movieID: Int) {
        guard var url = URLHelper.MovieList.movieDetail.url else { return }
        url.appendPathComponent("\(movieID)")
        
        NetworkingFramework.request(url: url, method: .get, urlQueries: [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "append_to_response", value: "videos,credits,release_dates")
        ])
            .response(dataType: MovieDetailModel.self) {[weak self] (data, response, error) in
                guard let data = data else {
                    self?.viewModel?.responseFromMovieDetail(isSuccess: false, data: nil, error: error)
                    return
                }
                
                self?.viewModel?.responseFromMovieDetail(isSuccess: true, data: data, error: error)
            }
    }
    
    
    weak var viewModel: MovieDetailWebServiceOutputProtocol?
    
    var apiKey: String? { UserDefaultsHelper.shared.apiKey }
}
