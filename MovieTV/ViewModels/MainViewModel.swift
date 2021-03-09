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
    var isMovieListIncludePaging: Bool { get }
    
    func viewDidLoad()
    func changedTagSelection(at index: Int)
    func callMovieListNextPage()
    func showSearchVC(from vc: UIViewController?)
    func showMovieDetailVC(at movieIndex: Int, from vc: UIViewController?, mainContainer: MainContainerViewDelegate?)
}

class MainViewModel: MainViewModelProtocol {
    func viewDidLoad() {
        webService?.getGenres()
        webService?.getMovieList(for: movieListType, genres: selectedGenreIDs, page: 1)
    }
    
    func changedTagSelection(at index: Int) {
        genres[index].isSelected.toggle()
        selectedGenreIDs = genres.compactMap({ $0.isSelected ? $0.id : nil })
        
        webService?.getMovieList(for: movieListType, genres: selectedGenreIDs, page: 1)
    }
    
    func callMovieListNextPage() {
        let newPage = (movieList?.page ?? 0) + 1
        
        webService?.getMovieList(for: movieListType, genres: selectedGenreIDs, page: newPage)
    }
    
    func showSearchVC(from vc: UIViewController?) {
        guard let fromVC = vc,
              let searchVC = SearchViewModel.createModule() else { return }
        
        searchVC.modalPresentationStyle = .fullScreen
        fromVC.present(searchVC, animated: true)
    }
    
    func showMovieDetailVC(at movieIndex: Int, from vc: UIViewController?, mainContainer: MainContainerViewDelegate?) {
        guard let fromVC = vc,
              let movieDetailVC = MovieDetailViewModel.createModule(with: movieList?.results[movieIndex], mainContainer: mainContainer) else { return }
        
        fromVC.navigationController?.pushViewController(movieDetailVC, animated: true)
    }
    
    static func createModule(isIncludeNavigation: Bool = false, mainContainer: MainContainerViewDelegate? = nil) -> UIViewController? {
        guard let viewController = UIViewController.MainViewController as? MainViewController else { return nil }
        
        var viewModel: MainViewModelProtocol & MovieListWebServiceOutputProtocol = MainViewModel()
        var webService: MovieListWebServiceInputProtocol = MovieListWebService()
        
        viewController.mainContainer = mainContainer
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
            webService?.getMovieList(for: movieListType, genres: selectedGenreIDs, page: 1)
        }
    }
    
    var isMovieListIncludePaging: Bool {
        let page = movieList?.page ?? 0
        let totalPage = movieList?.totalPages ?? 0
        return totalPage > page
    }
    
    private var selectedGenreIDs: [Int] = []
    
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
            changeMovieList(with: data)
            view?.changedMovieList()
        } else {
            view?.failedMovieList(with: error)
        }
    }
    
    private func changeMovieList(with data: MovieListModel) {
        guard let currentMovieList = movieList else {
            movieList = data
            return
        }
        
        var newData = data
        
        let currentPage = currentMovieList.page ?? 0
        let newPage = newData.page ?? 0
        
        if newPage > currentPage {
            newData.results = currentMovieList.results + data.results
        }
        
        movieList = newData
    }
}
