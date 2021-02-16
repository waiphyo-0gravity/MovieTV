//
//  MovieDetailViewModel.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/7/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol MovieDetailViewModelProtocol: AnyObject {
    var view: MovieDetailViewProtocol? { get set }
    var data: MovieModel? { get set }
    var imdbData: OMDBDataModel? { get set }
    var movieDetailData: MovieDetailModel? { get set }
    var webService: MovieDetailWebServiceInputProtocol? { get set }
    
    func viewDidLoad()
}

class MovieDetailViewModel: MovieDetailViewModelProtocol {
    func viewDidLoad() {
        guard let movieID = data?.id else { return }
        
        webService?.getMovieDetail(for: movieID)
    }
    
    private func getIMDBRating() {
        guard let imdbID = movieDetailData?.imdbID else { return }
        
        webService?.getIMDBRating(for: imdbID)
    }
    
    static func createModule(with data: MovieModel?) -> UIViewController? {
        guard let viewController = UIViewController.MovieDetailViewController as? MovieDetailViewController else { return nil }
        
        let viewModel: MovieDetailViewModelProtocol & MovieDetailWebServiceOutputProtocol = MovieDetailViewModel()
        var webService: MovieDetailWebServiceInputProtocol = MovieDetailWebService()
        
        viewController.viewModel = viewModel
        viewModel.view = viewController
        viewModel.data = data
        viewModel.webService = webService
        webService.viewModel = viewModel
        
        return viewController
    }
    
    weak var view: MovieDetailViewProtocol?
    var data: MovieModel?
    var imdbData: OMDBDataModel?
    var movieDetailData: MovieDetailModel?
    var webService: MovieDetailWebServiceInputProtocol?
}

//  MARK: - WEB_SERVICE -> VIEW_MODEL
extension MovieDetailViewModel: MovieDetailWebServiceOutputProtocol {
    func responseFromMovieDetail(isSuccess: Bool, data: MovieDetailModel?, error: Error?) {
        if isSuccess, let data = data {
            movieDetailData = data
            getIMDBRating()
            view?.handleMovieDetailChanged()
        } else {
            view?.failedMovieDetail(with: error)
        }
    }
    
    func responseFromIMDRating(isSuccess: Bool, data: OMDBDataModel?, error: Error?) {
        if isSuccess, let data = data {
            imdbData = data
            view?.handleIMDBRatingChanged()
        } else {
            view?.failedIMDBRating(with: error)
        }
    }
}
