//
//  AccountWebService.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/25/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import Foundation
import NetworkingFramework

protocol AccountWebServiceInputProtocol {
    var viewModel: AccountWebServiceOutputProtocol? { get set }
    var apiKey: String? { get }
    var sessionID: String? { get }
    
    func getAccountMovieList(for type: AccountMoviesViewModel.MovieListType?, page: Int)
    func postWatchMovieList(mediaID: Int, isAdding: Bool)
    func postFavouriteMovie(mediaID: Int, isAdding: Bool)
    func postRatingsMovie(movieID: Int, ratings: Float)
    func deleteRatingsMovie(movieID: Int)
}

protocol AccountWebServiceOutputProtocol: AnyObject {
    func responseFromAccountMovieList(isSuccess: Bool, data: MovieListModel?, error: Error?)
    func responseFromPostWatchMovie(isSuccess: Bool, error: Error?)
    func responseFromPostFavouriteMovie(isSuccess: Bool, error: Error?)
    func responseFromPostRatingMovie(isSuccess: Bool, error: Error?)
}

extension AccountWebServiceOutputProtocol {
    func responseFromAccountMovieList(isSuccess: Bool, data: MovieListModel?, error: Error?) {}
    func responseFromPostWatchMovie(isSuccess: Bool, error: Error?) {}
    func responseFromPostFavouriteMovie(isSuccess: Bool, error: Error?) {}
    func responseFromPostRatingMovie(isSuccess: Bool, error: Error?) {}
}

class AccountWebService: AccountWebServiceInputProtocol {
    func getAccountMovieList(for type: AccountMoviesViewModel.MovieListType?, page: Int) {
        guard let type = type,
              let url = getAccountMovieUrl(for: type) else { return }
        
        NetworkingFramework.request(
            url: url,
            method: .get,
            urlQueries: [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "session_id", value: sessionID),
                URLQueryItem(name: "sort_by", value: "created_at.desc"),
                URLQueryItem(name: "page", value: "\(page)")
            ]).response(dataType: MovieListModel.self) {[weak self] (data, response, error) in
                self?.viewModel?.responseFromAccountMovieList(isSuccess: data != nil, data: data, error: error)
            }
    }
    
    private func getAccountMovieUrl(for type: AccountMoviesViewModel.MovieListType?) -> URL? {
        switch type {
        case .favorite:
            return URLHelper.Account.favorite.url
        case .watchList:
            return URLHelper.Account.watchList.url
        case .ratedList:
            return URLHelper.Account.ratedList.url
        default:
            return nil
        }
    }
    
    func postWatchMovieList(mediaID: Int, isAdding: Bool) {
        postWatchMovieList?.cancel()
        
        guard let url = URLHelper.Account.addWatchList.url,
              let apiKey = apiKey,
              let sessionID = sessionID else { return }
        
        postWatchMovieList = NetworkingFramework.request(
            url: url,
            method: .post,
            urlQueries: [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "session_id", value: sessionID)
            ], bodyParameters: [
                "media_type": "movie",
                "media_id": mediaID,
                "watchlist": isAdding
            ]).response {[weak self] (_ , response, error) in
                self?.viewModel?.responseFromPostWatchMovie(isSuccess: response?.statusCode == 200, error: error)
            }
    }
    
    func postFavouriteMovie(mediaID: Int, isAdding: Bool) {
        postFavourateMovie?.cancel()
        
        guard let url = URLHelper.Account.addFavorite.url,
              let apiKey = apiKey,
              let sessionID = sessionID else { return }
        
        postFavourateMovie = NetworkingFramework.request(
            url: url,
            method: .post,
            urlQueries: [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "session_id", value: sessionID)
            ], bodyParameters: [
                "media_type": "movie",
                "media_id": mediaID,
                "favorite": isAdding
            ]).response {[weak self] (_ , response, error) in
                self?.viewModel?.responseFromPostFavouriteMovie(isSuccess: response?.statusCode == 200, error: error)
            }
    }
    
    func postRatingsMovie(movieID: Int, ratings: Float) {
        postRatingMovie?.cancel()
        
        guard let url = URLHelper.Account.addRatings(movieID: movieID).url,
              let apiKey = apiKey,
              let sessionID = sessionID else { return }
        
        postRatingMovie = NetworkingFramework.request(
            url: url,
            method: .post,
            urlQueries: [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "session_id", value: sessionID)
            ], bodyParameters: [
                "value": ratings
            ]).response {[weak self] (_ , response, error) in
                self?.viewModel?.responseFromPostRatingMovie(isSuccess: response?.statusCode == 200, error: error)
            }
    }
    
    func deleteRatingsMovie(movieID: Int) {
        postRatingMovie?.cancel()
        
        guard let url = URLHelper.Account.addRatings(movieID: movieID).url,
              let apiKey = apiKey,
              let sessionID = sessionID else { return }
        
        postRatingMovie = NetworkingFramework.request(
            url: url,
            method: .delete,
            urlQueries: [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "session_id", value: sessionID)
            ]).response {[weak self] (_ , response, error) in
                self?.viewModel?.responseFromPostRatingMovie(isSuccess: response?.statusCode == 200, error: error)
            }
    }
    
    weak var viewModel: AccountWebServiceOutputProtocol?
    var apiKey: String? { UserDefaultsHelper.shared.apiKey }
    var sessionID: String? {UserDefaultsHelper.shared.sessionID }
    
    private var postWatchMovieList: URLSessionDataTask?
    private var postFavourateMovie: URLSessionDataTask?
    private var postRatingMovie: URLSessionDataTask?
}
