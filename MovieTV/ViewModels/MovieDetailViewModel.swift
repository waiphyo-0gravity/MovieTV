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
    var accountWebService: AccountWebServiceInputProtocol? { get set }
    var movieStates: MovieStatesModel? { get set }
    var mappedUserType: UserDefaultsHelper.UserType? { get }
    
    func viewDidAppear()
    func handleWatchMovieStateChange()
    func handleFavourateMovieStateChange()
    func handleClickedRatingBtn(_ sender: UIButton, from vc: UIViewController?)
}

class MovieDetailViewModel: MovieDetailViewModelProtocol {
    func viewDidAppear() {
        guard let movieID = data?.id else { return }
        
        webService?.getMovieDetail(for: movieID)
        webService?.getMovieStates(for: movieID)
    }
    
    private func getIMDBRating() {
        guard let imdbID = movieDetailData?.imdbID else { return }
        
        webService?.getIMDBRating(for: imdbID)
    }
    
    func handleWatchMovieStateChange() {
        guard let mediaID = data?.id else { return }
        
        movieStates?.watchlist?.toggle()
        
        accountWebService?.postWatchMovieList(mediaID: mediaID, isAdding: movieStates?.watchlist == true)
    }
    
    func handleFavourateMovieStateChange() {
        guard let mediaID = data?.id else { return }
        
        movieStates?.favorite?.toggle()
        
        accountWebService?.postFavouriteMovie(mediaID: mediaID, isAdding: movieStates?.favorite == true)
    }
    
    func handleClickedRatingBtn(_ sender: UIButton, from vc: UIViewController?) {
        guard let ratingVC = UIViewController.RatingViewController as? RatingViewController else { return }
        
        if case .ratedStatusData(let ratedData) = movieStates?.rated,
           let ratedValue = ratedData.value {
            ratingVC.currentRating = ratedValue / 2
        }
        
        ratingVC.preferredContentSize = RatingViewController.ratingVCSize
        
        ratingVC.delegate = self
        
        ratingVC.modalPresentationStyle = .popover
        
        let popOverVC = ratingVC.popoverPresentationController
        popOverVC?.delegate = vc as? UIPopoverPresentationControllerDelegate
        popOverVC?.backgroundColor = .white
        popOverVC?.sourceView = sender
        popOverVC?.sourceRect = sender.bounds
        popOverVC?.permittedArrowDirections = [.down, .up]
        
        vc?.present(ratingVC, animated: true)
    }
    
    static func createModule(with data: MovieModel?, mainContainer: MainContainerViewDelegate?) -> UIViewController? {
        guard let viewController = UIViewController.MovieDetailViewController as? MovieDetailViewController else { return nil }
        
        let viewModel: MovieDetailViewModelProtocol & MovieDetailWebServiceOutputProtocol & AccountWebServiceOutputProtocol = MovieDetailViewModel()
        var webService: MovieDetailWebServiceInputProtocol = MovieDetailWebService()
        var accountWebService: AccountWebServiceInputProtocol = AccountWebService()
        
        viewController.mainContainer = mainContainer
        viewController.viewModel = viewModel
        viewModel.view = viewController
        viewModel.data = data
        viewModel.webService = webService
        viewModel.accountWebService = accountWebService
        accountWebService.viewModel = viewModel
        webService.viewModel = viewModel
        
        return viewController
    }
    
    weak var view: MovieDetailViewProtocol?
    var data: MovieModel?
    var imdbData: OMDBDataModel?
    var movieDetailData: MovieDetailModel?
    var webService: MovieDetailWebServiceInputProtocol?
    var accountWebService: AccountWebServiceInputProtocol?
    var movieStates: MovieStatesModel? = .init(id: 0, favorite: false, rated: .ratedStatus(false), watchlist: false)
    var mappedUserType: UserDefaultsHelper.UserType? { UserDefaultsHelper.shared.mappedUserType }
}
//  MARK: - Rating view delegates.
extension MovieDetailViewModel: RatingViewControllerDelegate {
    func handleRatingChanged(rating: Float) {
        guard let movieID = data?.id else { return }

        if rating <= 0 {
            accountWebService?.deleteRatingsMovie(movieID: movieID)
            movieStates?.rated = .ratedStatus(false)
        } else {
            accountWebService?.postRatingsMovie(movieID: movieID, ratings: rating)
            movieStates?.rated = .ratedStatusData(.init(value: rating))
            
            if movieStates?.watchlist != false {
                movieStates?.watchlist = false
                view?.handleWatchListStateChange()
            }
        }
        
        view?.handleRatingStateChange()
    }
}

//  MARK: - WEB_SERVICE -> VIEW_MODEL
extension MovieDetailViewModel: MovieDetailWebServiceOutputProtocol, AccountWebServiceOutputProtocol {
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
    
    func responseFromMovieStates(isSuccess: Bool, data: MovieStatesModel?, error: Error?) {
        if isSuccess, let data = data {
            movieStates = data
            view?.handleMovieStatesChanged()
        } else {
            view?.failedMovieStates(with: error)
        }
    }
}
