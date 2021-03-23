//
//  MovieDetailViewController.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/7/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol MovieDetailViewProtocol: AnyObject {
    var viewModel: MovieDetailViewModelProtocol? { get set }
    var mainContainer: MainContainerViewDelegate? { get set }
    
    func handleMovieDetailChanged()
    func failedMovieDetail(with error: Error?)
    func handleIMDBRatingChanged()
    func failedIMDBRating(with error: Error?)
    func handleMovieStatesChanged()
    func failedMovieStates(with error: Error?)
    func handleWatchListStateChange()
    func handleRatingStateChange()
    func handleFavourateStateChange()
}

class MovieDetailViewController: ViewController, UIPopoverPresentationControllerDelegate {
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statusBarHidableNavController?.changeStatusBar(isHidden: true)
        mainContainer?.changeStatusBar(to: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.viewDidAppear()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    @IBAction func clickedRatingBtn(_ sender: UIButton) {
        viewModel?.handleClickedRatingBtn(sender, from: self)
    }
    
    @objc func clickedNavBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func clickedWatchlistBtn() {
        viewModel?.handleWatchMovieStateChange()
        handleWatchListStateChange()
    }
    
    private func initial() {
        movieDetailTableView.isGuestUser = viewModel?.mappedUserType == .guest
        movieDetailTableView.data = viewModel?.data
        movieDetailTableView.customDelegate = self
        
        setUpTopViews()
        setUpRatingContainerView()
        setUpRatingView()
        animateIMDBRatingView(isShow: false, isAnimate: false)
    }
    
    private func setUpTopViews() {
        let url = URLHelper.Image.customWidth(500, viewModel?.data?.posterPath).urlStr
        topMediaScrollView.movieCoverImgView.setImg(url: url)
        movieNavItem?.leftBackBtn.addTarget(self, action: #selector(clickedNavBack), for: .touchUpInside)
        movieNavItem?.watchListBtn.addTarget(self, action: #selector(clickedWatchlistBtn), for: .touchUpInside)
        
        movieCoverImgViewBottomConstraint.constant = Self.coverBottomConstant
        topMediaScrollView.customDelegate = self
    }
    
    private func setUpRatingContainerView() {
        ratingContainerView.layer.cornerRadius = 96 / 2
        ratingContainerView.addAccentShadow()
    }
    
    private func setUpRatingView() {
        let data = viewModel?.data
        let isVoteAverageInValid = data?.voteAverage == 0 || data?.voteAverage == nil
        
        ratingRatioLbl.text = isVoteAverageInValid ? "N/A" : "\(data?.voteAverage ?? 0.0)/10"
        
        ratingCountLbl.text = isVoteAverageInValid ? "N/A" : "\(data?.voteCount ?? 0)"
    }
    
    func handleWatchListStateChange() {
        movieNavItem?.watchListBtn.tintColor = viewModel?.movieStates?.watchlist == true ? .R100 : .white
    }
    
    private func animateIMDBRatingView(isShow: Bool, isAnimate: Bool = true) {
        UIView.easeSpringAnimation(isAnimate: isAnimate) {[weak self] in
            self?.imdbVoteCountLbl.transform = isShow ? .identity : .init(translationX: 0, y: 24)
            self?.imdbLogoImgView.transform = isShow ? .identity : .init(translationX: 0, y: -24)
            self?.imdbScoreLbl.transform = isShow ? .identity : .init(scaleX: 0.009, y: 0.009)
            self?.imdbRatingContainerView.alpha = isShow ? 1 : 0
        }
    }
    
    @IBOutlet weak var movieDetailTableView: MovieDetailTableView!
    @IBOutlet weak var movieCoverImgViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var ratingContainerView: UIView!
    @IBOutlet weak var ratingRatioLbl: UILabel!
    @IBOutlet weak var ratingCountLbl: UILabel!
    @IBOutlet weak var ratingBtn: MovieTVButton!
    @IBOutlet weak var topMediaScrollView: MainTopMediaScrollView!
    @IBOutlet weak var ratingContainerViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var imdbRatingContainerView: UIView!
    @IBOutlet weak var imdbScoreLbl: UILabel!
    @IBOutlet weak var imdbVoteCountLbl: UILabel!
    @IBOutlet weak var imdbLogoImgView: UIImageView!
    @IBOutlet weak var ratingProgressView: UIView!
    
    var movieNavItem: MovieDetailNavigationItem? {
        return navigationItem as? MovieDetailNavigationItem
    }
    
    var mainNavigationController: MainNavViewcontroller? {
        return navigationController as? MainNavViewcontroller
    }
    
    private var statusBarHidableNavController: StatusBarHidableNavController? {
        return navigationController as? StatusBarHidableNavController
    }
    
    static let coverBottomConstant: CGFloat = UIScreen.main.bounds.height * 0.3
    static let minCoverbottomConstant: CGFloat = 52
    static let minRatingContainerCenterYConstant: CGFloat = 16
    
    var viewModel: MovieDetailViewModelProtocol?
    var mainContainer: MainContainerViewDelegate?
}

//  MARK: - Movie table view custom delegates.
extension MovieDetailViewController: MovieDetailTableViewDelegate, MainTopMediaScrollViewDelegate {
    func mainScrollViewDidScroll(scrollView: UIScrollView) {
        let lowerBound = min(1, scrollView.contentOffset.x / scrollView.frame.width)
        let upperBound = max(0, lowerBound)
        
        let newConstant = Self.minRatingContainerCenterYConstant + 32 * upperBound
        
        guard ratingContainerViewCenterYConstraint.constant != newConstant else { return }
        
        ratingContainerViewCenterYConstraint.constant = newConstant
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let actualContentOffsetY = scrollView.contentOffset.y + movieDetailTableView.contentInset.top
        let newBottomConstant = max(Self.minCoverbottomConstant, Self.coverBottomConstant - actualContentOffsetY)
        
        let percentage = calculateScrolledPercentage(const: newBottomConstant)
        
        topMediaScrollView.setBackgroundBlurViewAlpha(to: 1 - percentage)
        
        movieCoverImgViewBottomConstraint.constant = newBottomConstant
        
        topMediaScrollView.layoutIfNeeded()
    }
    
    func handleClickedFavorite() {
        viewModel?.handleFavourateMovieStateChange()
    }
    
    private func calculateScrolledPercentage(const: CGFloat) -> CGFloat {
        let percentage = (const - Self.minCoverbottomConstant) / (Self.coverBottomConstant - Self.minCoverbottomConstant)
        return min(1, percentage)
    }
}

//  MARK: - VIEW_MODEL -> VIEW
extension MovieDetailViewController: MovieDetailViewProtocol {
    func handleMovieDetailChanged() {
        movieDetailTableView.movieDetailData = viewModel?.movieDetailData
        topMediaScrollView.data = viewModel?.movieDetailData?.videos
    }
    
    func failedMovieDetail(with error: Error?) {
        print(error)
    }
    
    func handleIMDBRatingChanged() {
        let imdbScore = viewModel?.imdbData?.imdbRating ?? "N/A"
        imdbScoreLbl.text = imdbScore == "N/A" ? imdbScore : "\(imdbScore)/10"
        imdbVoteCountLbl.text = viewModel?.imdbData?.imdbVotes
        
        let rated = viewModel?.imdbData?.rated
        movieDetailTableView.certificatedRating = rated == "N/A" ? nil : rated
        
        animateIMDBRatingView(isShow: true)
    }
    
    func handleRatingStateChange() {
        var ratedStars: Float = 0
        
        if case .ratedStatusData(let ratedData) = viewModel?.movieStates?.rated {
            ratedStars = ratedData.value ?? 0
        }
        
        ratedStars /= 10
        
        UIView.easeSpringAnimation {
            self.ratingProgressView.transform = .init(translationX: CGFloat(ratedStars * 24), y: 0)
        }
    }
    
    func handleFavourateStateChange() {
        movieDetailTableView.isFavourate = viewModel?.movieStates?.favorite == true
    }
    
    func failedIMDBRating(with error: Error?) {
        print(error)
    }
    
    func handleMovieStatesChanged() {
        handleWatchListStateChange()
        handleRatingStateChange()
        handleFavourateStateChange()
    }
    
    func failedMovieStates(with error: Error?) {
        print(error)
    }
}
