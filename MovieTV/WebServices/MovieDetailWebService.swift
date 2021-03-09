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
    var sessionID: String? { get }
    
    func getMovieDetail(for movieID: Int)
    func getIMDBRating(for imdbID: String)
    func getMovieStates(for movieID: Int)
}

protocol MovieDetailWebServiceOutputProtocol: AnyObject {
    func responseFromMovieDetail(isSuccess: Bool, data: MovieDetailModel?, error: Error?)
    func responseFromIMDRating(isSuccess: Bool, data: OMDBDataModel?, error: Error?)
    func responseFromMovieStates(isSuccess: Bool, data: MovieStatesModel?, error: Error?)
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
    
    func getIMDBRating(for imdbID: String) {
        guard let url = URLHelper.MovieList.imdb.url else { return }
        
        NetworkingFramework.request(url: url, method: .get, urlQueries: [
            URLQueryItem(name: "apikey", value: URLHelper.omdbAPIKey),
            URLQueryItem(name: "i", value: imdbID)
        ])
            .response(dataType: OMDBDataModel.self) {[weak self] (data, response, error) in
                guard let data = data else {
                    self?.viewModel?.responseFromIMDRating(isSuccess: false, data: nil, error: error)
                    return
                }
                
                self?.viewModel?.responseFromIMDRating(isSuccess: true, data: data, error: error)
            }
    }
    
    func getMovieStates(for movieID: Int) {
        guard let url = URLHelper.MovieList.movieStates(movieID: movieID).url else { return }
        
        NetworkingFramework.request(url: url, method: .get, urlQueries: [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "session_id", value: sessionID)
        ])
            .response(dataType: MovieStatesModel.self) {[weak self] (data, response, error) in
                guard let data = data else {
                    self?.viewModel?.responseFromMovieStates(isSuccess: false, data: nil, error: error)
                    return
                }
                
                self?.viewModel?.responseFromMovieStates(isSuccess: true, data: data, error: error)
            }
    }
    
    weak var viewModel: MovieDetailWebServiceOutputProtocol?
    
    var apiKey: String? { UserDefaultsHelper.shared.apiKey }
    var sessionID: String? { UserDefaultsHelper.shared.sessionID }
}
