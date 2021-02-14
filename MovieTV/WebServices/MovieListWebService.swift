//
//  MovieListWebService.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/13/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import Foundation
import NetworkingFramework

protocol MovieListWebServiceInputProtocol {
    var viewModel: MovieListWebServiceOutputProtocol? { get set }
    var apiKey: String? { get }
    
    func getGenres()
    func getMovieList(for listType: MainViewModel.MovieListType)
}

protocol MovieListWebServiceOutputProtocol: AnyObject {
    func responseFromGenre(isSuccess: Bool, data: GenresResponseModel?, error: Error?)
    func responseFromMovieList(isSuccess: Bool, data: MovieListModel?, error: Error?)
}

//  MARK: - Declare optional functions.
extension MovieListWebServiceOutputProtocol {
    func responseFromGenre(isSuccess: Bool, data: GenresResponseModel?, error: Error?) {}
    func responseFromMovieList(isSuccess: Bool, data: MovieListModel?, error: Error?) {}
}

class MovieListWebService: MovieListWebServiceInputProtocol {
    func getGenres() {
        guard let url = URLHelper.MovieList.genres.url else { return }
        
        NetworkingFramework.request(url: url, method: .get, urlQueries: [URLQueryItem(name: "api_key", value: apiKey)])
            .response(dataType: GenresResponseModel.self) {[weak self] (data, response, error) in
                
                guard let data = data else {
                    self?.viewModel?.responseFromGenre(isSuccess: false, data: nil, error: error)
                    return
                }
                
                self?.viewModel?.responseFromGenre(isSuccess: true, data: data, error: error)
            }
    }
    
    func getMovieList(for listType: MainViewModel.MovieListType) {
        guard let url = URLHelper.MovieList.movieList(listType).url else { return }
        
        movieListReq?.cancel()
        
        movieListReq = NetworkingFramework.request(url: url, method: .get, urlQueries: [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: "en-US")
        ])
            .response(dataType: MovieListModel.self) {[weak self] (data, response, error) in
                self?.movieListReq = nil
                
                guard let data = data else {
                    self?.viewModel?.responseFromMovieList(isSuccess: false, data: nil, error: error)
                    return
                }
                
                self?.viewModel?.responseFromMovieList(isSuccess: true, data: data, error: error)
            }
    }
    
    weak var viewModel: MovieListWebServiceOutputProtocol?
    var apiKey: String? { UserDefaultsHelper.shared.apiKey }
    
    private var movieListReq: URLSessionDataTask?
}
