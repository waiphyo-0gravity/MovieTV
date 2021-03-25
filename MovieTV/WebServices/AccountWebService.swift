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
    var guestSessionID: String? { get }
    var mappedUserType: UserDefaultsHelper.UserType? { get }
    
    func getAccountMovieList(for type: AccountMoviesViewModel.MovieListType?, page: Int)
    func postWatchMovieList(mediaID: Int, isAdding: Bool)
    func postFavouriteMovie(mediaID: Int, isAdding: Bool)
    func postRatingsMovie(movieID: Int, ratings: Float)
    func deleteRatingsMovie(movieID: Int)
    func getAccountDetail()
}

protocol AccountWebServiceOutputProtocol: AnyObject {
    func responseFromAccountMovieList(isSuccess: Bool, data: MovieListModel?, error: Error?)
    func responseFromPostWatchMovie(isSuccess: Bool, error: Error?)
    func responseFromPostFavouriteMovie(isSuccess: Bool, error: Error?)
    func responseFromPostRatingMovie(isSuccess: Bool, error: Error?)
    func responseFromAccountDetail(isSuccess: Bool, data: AccountDetailModel?, error: Error?)
}

extension AccountWebServiceOutputProtocol {
    func responseFromAccountMovieList(isSuccess: Bool, data: MovieListModel?, error: Error?) {}
    func responseFromPostWatchMovie(isSuccess: Bool, error: Error?) {}
    func responseFromPostFavouriteMovie(isSuccess: Bool, error: Error?) {}
    func responseFromPostRatingMovie(isSuccess: Bool, error: Error?) {}
    func responseFromAccountDetail(isSuccess: Bool, data: AccountDetailModel?, error: Error?) {}
}

class AccountWebService: AccountWebServiceInputProtocol {
    func getAccountMovieList(for type: AccountMoviesViewModel.MovieListType?, page: Int) {
        guard let type = type,
              let url = getAccountMovieUrl(for: type) else { return }
        
        var urlQueries = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "sort_by", value: "created_at.desc"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        if mappedUserType == .normal {
            urlQueries.append(URLQueryItem(name: "session_id", value: sessionID))
        }
        
        NetworkingFramework.request(
            url: url,
            method: .get,
            urlQueries: urlQueries)
            .response(dataType: MovieListModel.self) {[weak self] (data, response, error) in
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
            return URLHelper.Account.ratedList(userType: mappedUserType, guestSessionID: guestSessionID).url
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
              let apiKey = apiKey else { return }
        
        var urlQueries = [URLQueryItem(name: "api_key", value: apiKey)]
            
        if mappedUserType == .normal {
            urlQueries.append(URLQueryItem(name: "session_id", value: sessionID))
        } else if mappedUserType == .guest {
            urlQueries.append(URLQueryItem(name: "guest_session_id", value: guestSessionID))
        }
        
        postRatingMovie = NetworkingFramework.request(
            url: url,
            method: .post,
            urlQueries: urlQueries, bodyParameters: [
                "value": ratings
            ]).response {[weak self] (_ , response, error) in
                self?.viewModel?.responseFromPostRatingMovie(isSuccess: response?.statusCode == 200, error: error)
            }
    }
    
    func deleteRatingsMovie(movieID: Int) {
        postRatingMovie?.cancel()
        
        guard let url = URLHelper.Account.addRatings(movieID: movieID).url,
              let apiKey = apiKey else { return }
        
        var urlQueries = [URLQueryItem(name: "api_key", value: apiKey)]
            
        if mappedUserType == .normal {
            urlQueries.append(URLQueryItem(name: "session_id", value: sessionID))
        } else if mappedUserType == .guest {
            urlQueries.append(URLQueryItem(name: "guest_session_id", value: guestSessionID))
        }
        
        postRatingMovie = NetworkingFramework.request(
            url: url,
            method: .delete,
            urlQueries: urlQueries).response {[weak self] (_ , response, error) in
                self?.viewModel?.responseFromPostRatingMovie(isSuccess: response?.statusCode == 200, error: error)
            }
    }
    
    func getAccountDetail() {
        guard let url = URLHelper.Account.accountDetail.url,
              let apiKey = apiKey else { return }
        
        var urlQueries = [URLQueryItem(name: "api_key", value: apiKey)]
            
        if mappedUserType == .normal {
            urlQueries.append(URLQueryItem(name: "session_id", value: sessionID))
        } else if mappedUserType == .guest {
            urlQueries.append(URLQueryItem(name: "guest_session_id", value: guestSessionID))
        }
        
        postRatingMovie = NetworkingFramework.request(
            url: url,
            method: .get,
            urlQueries: urlQueries).response(dataType: AccountDetailModel.self) {[weak self] (data , response, error) in
                self?.viewModel?.responseFromAccountDetail(isSuccess: data != nil, data: data, error: error)
            }
    }
    
    weak var viewModel: AccountWebServiceOutputProtocol?
    var apiKey: String? { URLHelper.apiKey }
    var sessionID: String? { UserDefaultsHelper.shared.sessionID }
    var guestSessionID: String? { UserDefaultsHelper.shared.guestSessionID }
    var mappedUserType: UserDefaultsHelper.UserType? { UserDefaultsHelper.shared.mappedUserType }
    
    private var postWatchMovieList: URLSessionDataTask?
    private var postFavourateMovie: URLSessionDataTask?
    private var postRatingMovie: URLSessionDataTask?
}
