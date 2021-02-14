//
//  AuthenticationViewModel.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/13/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol MainViewModelProtocol {
    var view: MainViewProtocol? { get set }
    var webService: MovieListWebServiceInputProtocol? { get set }
    var movieListType: MainViewModel.MovieListType { get set }
    var genres: [GenreModel] { get set }
    var movieList: MovieListModel? { get set }
    
    func viewDidLoad()
    func showMovieDetailVC(at movieIndex: Int, from vc: UIViewController?)
}

class MainViewModel: MainViewModelProtocol {
    func viewDidLoad() {
        webService?.getGenres()
        webService?.getMovieList(for: movieListType)
    }
    
    func showMovieDetailVC(at movieIndex: Int, from vc: UIViewController?) {
        guard let fromVC = vc,
              let movieDetailVC = MovieDetailViewModel.createModule(with: movieList?.results[movieIndex]) else { return }
        
        fromVC.navigationController?.pushViewController(movieDetailVC, animated: true)
    }
    
    static func createModule(isIncludeNavigation: Bool = false) -> UIViewController? {
        guard let viewController = UIViewController.MainViewController as? MainViewController else { return nil }
        
        var viewModel: MainViewModelProtocol & MovieListWebServiceOutputProtocol = MainViewModel()
        var webService: MovieListWebServiceInputProtocol = MovieListWebService()
        
        viewController.viewModel = viewModel
        viewModel.view = viewController
        viewModel.webService = webService
        webService.viewModel = viewModel
        
        guard !isIncludeNavigation else {
            let naVC = MainNavViewcontroller(rootViewController: viewController)
            
            return naVC
        }
        
        return viewController
    }
    
    weak var view: MainViewProtocol?
    var webService: MovieListWebServiceInputProtocol?
    var genres: [GenreModel] = []
    var movieList: MovieListModel?
    
    var movieListType: MovieListType = .inTheater {
        didSet {
            webService?.getMovieList(for: movieListType)
        }
    }
    
    enum MovieListType: CaseIterable {
        case inTheater, upComing, popular, recommendations
        
        var name: String {
            switch self {
            case .inTheater:
                return "In Theater"
            case .upComing:
                return "Up Coming"
            case .recommendations:
                return "Recommendations"
            case .popular:
                return "Popular"
            }
        }
    }
}

//  MARK: - WEB_SERVICES -> VIEW_MODEL
extension MainViewModel: MovieListWebServiceOutputProtocol {
    func responseFromGenre(isSuccess: Bool, data: GenresResponseModel?, error: Error?) {
        if isSuccess, let data = data {
            genres = data.genres
            GenresMapHelper.shared.genres = genres
            
            view?.changedGenresList()
        } else {
            view?.failedGenresList(with: error)
        }
    }
    
    func responseFromMovieList(isSuccess: Bool, data: MovieListModel?, error: Error?) {
        if isSuccess, let data = data {
            movieList = data
            view?.changedMovieList()
        } else {
            view?.failedMovieList(with: error)
        }
    }
}
