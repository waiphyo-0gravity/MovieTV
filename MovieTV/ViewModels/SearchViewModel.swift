//
//  SearchViewModel.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/23/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol SearchViewModelProtocol: AnyObject {
    var view: SearchViewProtocol? { get set }
    var webService: SearchWebServiceInputProtocol? { get set }
    var searchedMovies: MovieListModel? { get set }
    var isMovieListIncludePaging: Bool { get }
    
    func search(for keyword: String?)
    func callSearchMovieListNextPage(for keyword: String?)
    func showMovieDetail(at index: Int, view: UINavigationController?)
}

class SearchViewModel: SearchViewModelProtocol {
    static func createModule(isNavigationInclude: Bool = true) -> UIViewController? {
        guard let viewController = UIViewController.SearchViewController as? SearchViewController else { return nil }
        
        let viewModel: SearchViewModelProtocol & SearchWebServiceOutputProtocol = SearchViewModel()
        var webService: SearchWebServiceInputProtocol = SearchWebService()
        
        viewController.viewModel = viewModel
        viewModel.view = viewController
        viewModel.webService = webService
        webService.viewModel = viewModel
        
        guard isNavigationInclude else {
            return viewController
        }
        
        let navVC = StatusBarHidableNavController(rootViewController: viewController)
        navVC.navigationBar.prefersLargeTitles = true
        return navVC
    }
    
    func search(for keyword: String?) {
        guard let keyword = keyword, keyword.isEmpty == false else {
            searchedMovies = nil
            view?.handleSearchedMoviesChanged()
            webService?.searchReq?.cancel()
            return
        }
        
        webService?.searchMovie(with: keyword, page: 1)
    }
    
    func callSearchMovieListNextPage(for keyword: String?) {
        guard let keyword = keyword, keyword.isEmpty == false else {
            searchedMovies = nil
            view?.handleSearchedMoviesChanged()
            webService?.searchReq?.cancel()
            return
        }
        
        let page = (searchedMovies?.page ?? 0) + 1
        
        webService?.searchMovie(with: keyword, page: page)
    }
    
    func showMovieDetail(at index: Int, view: UINavigationController?) {
        guard let movieDetailVC = MovieDetailViewModel.createModule(with: searchedMovies?.results[index], mainContainer: nil) else { return }
        
        view?.pushViewController(movieDetailVC, animated: true)
    }
    
    weak var view: SearchViewProtocol?
    var searchedMovies: MovieListModel?
    var webService: SearchWebServiceInputProtocol?
    
    var isMovieListIncludePaging: Bool {
        let page = searchedMovies?.page ?? 0
        let totalPage = searchedMovies?.totalPages ?? 0
        return totalPage > page
    }
}

//  MARK: - WEB_SERVICE -> VIEW_MODEL
extension SearchViewModel: SearchWebServiceOutputProtocol {
    func responseFromSearchMovie(isSuccess: Bool, data: MovieListModel?, error: Error?) {
        guard let data = data else {
            return
        }
        
//        searchedMovies = data
        changeMovieList(with: data)
        view?.handleSearchedMoviesChanged()
    }
    
    private func changeMovieList(with data: MovieListModel?) {
        guard let currentMovieList = searchedMovies else {
            searchedMovies = data
            return
        }
        
        var newData = data
        
        let currentPage = currentMovieList.page ?? 0
        let newPage = newData?.page ?? 0
        
        if newPage > currentPage {
            newData?.results = currentMovieList.results + (data?.results ?? [])
        }
        
        searchedMovies = newData
    }
}
