//
//  URLHelper.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/13/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import Foundation

protocol URLHelperProtocol {
    var url: URL? { get }
    var path: String { get }
}

enum URLHelper {
    static let version = "3"
    static let baseURL = "https://api.themoviedb.org/\(version)"
    static let omdbBaseURL = "http://www.omdbapi.com/?"
    static let imgBaseURL = "https://image.tmdb.org/t/p"
    static let movieID = "2"
    static let omdbAPIKey = "c38199c1"
    
    enum Image {
        case original(String?), customWidth(Int, String?)
        
        var urlStr: String? {
            switch self {
            case .original(let url):
                guard let url = url else { return nil }
                
                return "\(URLHelper.imgBaseURL)/original/\(url)"
            case .customWidth(let width, let url):
                guard let url = url else { return nil}
                
                return "\(URLHelper.imgBaseURL)/w\(width)/\(url)"
            }
        }
    }
    
    enum Authentication: URLHelperProtocol {
        case requestToken, requestTokenWithLogin, createSession
        
        var url: URL? {
            return URL(string: "\(URLHelper.baseURL)\(path)")
        }
        
        var path: String {
            switch self {
            case .requestToken:
                return "/authentication/token/new"
            case .requestTokenWithLogin:
                return "/authentication/token/validate_with_login"
            case .createSession:
                return "/authentication/session/new"
            }
        }
    }
    
    enum MovieList: URLHelperProtocol {
        case genres, movieList(MainViewModel.MovieListType), movieDetail, imdb
        
        var url: URL? {
            switch self {
            case .imdb:
                return URL(string: "\(URLHelper.omdbBaseURL)")
            default:
                return URL(string: "\(URLHelper.baseURL)\(path)")
            }
        }
        
        var path: String {
            switch self {
            case .genres:
                return "/genre/movie/list"
            case .movieList(let type):
                return getMoveListPath(for: type)
            case .movieDetail:
                return "/movie/"
            case .imdb:
                return ""
            }
        }
        
        private func getMoveListPath(for type: MainViewModel.MovieListType) -> String {
            switch type {
            case .inTheater:
                return "/movie/now_playing"
            case .upComing:
                return "/movie/upcoming"
            case .popular:
                return "/movie/popular"
            case .recommendations:
                return "/movie/\(URLHelper.movieID)/recommendations"
            }
        }
    }
}
