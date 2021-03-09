//
//  AccountMoviesViewModel.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/25/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol AccountMoviesViewModelProtocol: AnyObject {
    var view: AccountMoviesViewProtocol? { get set }
    var webService: AccountWebServiceInputProtocol? { get set }
    var accountMovies: MovieListModel? { get set }
    var movieListType: AccountMoviesViewModel.MovieListType? { get set }
    var isMovieListIncludePaging: Bool { get }
    
    func getAccountMovies()
    func callAccountMovieListNextPage()
    func showMovieDetail(at index: Int, view: UINavigationController?)
}

class AccountMoviesViewModel: AccountMoviesViewModelProtocol {
    static func createModule(isNavigationInclude: Bool = true, movieListType: MovieListType? = .watchList) -> UIViewController? {
        guard let viewController = UIViewController.AccountMoviesViewController as? AccountMoviesViewController else { return nil }
        
        let viewModel: AccountMoviesViewModelProtocol & AccountWebServiceOutputProtocol = AccountMoviesViewModel()
        var webService: AccountWebServiceInputProtocol = AccountWebService()
        
        viewController.viewModel = viewModel
        viewModel.view = viewController
        viewModel.webService = webService
        viewModel.movieListType = movieListType
        webService.viewModel = viewModel
        
        guard isNavigationInclude else {
            return viewController
        }
        
        let AccountMoviesNavc = StatusBarHidableNavController(rootViewController: viewController)
        
        AccountMoviesNavc.navigationBar.prefersLargeTitles = true
        return AccountMoviesNavc
    }
    
    func getAccountMovies() {
        webService?.getAccountMovieList(for: movieListType, page: 1)
    }
    
    func callAccountMovieListNextPage() {
        let newPage = (accountMovies?.page ?? 0) + 1
        
        webService?.getAccountMovieList(for: movieListType, page: newPage)
    }
    
    func showMovieDetail(at index: Int, view: UINavigationController?) {
        guard let view = view,
              let moviewDetail = MovieDetailViewModel.createModule(with: accountMovies?.results[index], mainContainer: nil) else { return }
        
        view.pushViewController(moviewDetail, animated: true)
    }
    
    enum MovieListType {
        case favorite, watchList, ratedList
        
        var navigationTitle: String {
            switch self {
            case .favorite:
                return "Favorite"
            case .watchList:
                return "Watchlist"
            case .ratedList:
                return "Ratings"
            }
        }
    }
    
    weak var view: AccountMoviesViewProtocol?
    var webService: AccountWebServiceInputProtocol?
    var accountMovies: MovieListModel?
    var movieListType: MovieListType?
    
    var isMovieListIncludePaging: Bool {
        let page = accountMovies?.page ?? 0
        let totalPage = accountMovies?.totalPages ?? 0
        return totalPage > page
    }
}

//  MARK: - WEB_SERVICE -> VIEW_MODEL
extension AccountMoviesViewModel: AccountWebServiceOutputProtocol {
    func responseFromAccountMovieList(isSuccess: Bool, data: MovieListModel?, error: Error?) {
        changeMovieList(with: data)
        view?.handleAccountMoviesDataChanged()
    }
    
    private func changeMovieList(with data: MovieListModel?) {
        guard let currentMovieList = accountMovies else {
            accountMovies = data
            return
        }
        
        var newData = data
        
        let currentPage = currentMovieList.page ?? 0
        let newPage = newData?.page ?? 0
        
        if newPage > currentPage {
            newData?.results = currentMovieList.results + (data?.results ?? [])
        }
        
        accountMovies = newData
    }
}
