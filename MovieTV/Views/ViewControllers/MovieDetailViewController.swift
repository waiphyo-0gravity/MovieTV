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
    
    func handleMovieDetailChanged()
    func failedMovieDetail(with error: Error?)
    func handleIMDBRatingChanged()
    func failedIMDBRating(with error: Error?)
}

class MovieDetailViewController: ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
        viewModel?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @objc func clickedNavBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func initial() {
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
        mainNavigationController?.isStatusBarHidden = true
        mainNavigationController?.setNeedsStatusBarAppearanceUpdate()
        
        topMediaScrollView.customDelegate = self
    }
    
    private func setUpRatingContainerView() {
        ratingContainerView.layer.cornerRadius = 96 / 2
        ratingContainerView.layer.shadowOffset = .init(width: -1, height: -2)
        ratingContainerView.layer.shadowRadius = 20
        ratingContainerView.layer.shadowPath = nil
        ratingContainerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        ratingContainerView.layer.shadowOpacity = 1
    }
    
    private func setUpRatingView() {
        let data = viewModel?.data
        let isVoteAverageInValid = data?.voteAverage == 0 || data?.voteAverage == nil
        
        ratingRatioLbl.text = isVoteAverageInValid ? "N/A" : "\(data?.voteAverage ?? 0.0)/10"
        
        ratingCountLbl.text = isVoteAverageInValid ? "N/A" : "\(data?.voteCount ?? 0)"
    }
    
    private func animateIMDBRatingView(isShow: Bool, isAnimate: Bool = true) {
        UIView.easeSpringAnimation(isAnimate: isAnimate) {[weak self] in
            self?.imdbRatingContainerView.transform = isShow ? .identity : .init(translationX: 24, y: 0)
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
    
    var movieNavItem: MovieDetailNavigationItem? {
        return navigationItem as? MovieDetailNavigationItem
    }
    
    var mainNavigationController: MainNavViewcontroller? {
        return navigationController as? MainNavViewcontroller
    }
    
    static let coverBottomConstant: CGFloat = UIScreen.main.bounds.height * 0.3
    static let minCoverbottomConstant: CGFloat = 52
    static let minRatingContainerCenterYConstant: CGFloat = 16
    
    var viewModel: MovieDetailViewModelProtocol?
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
        
        print(percentage)
        
        movieCoverImgViewBottomConstraint.constant = newBottomConstant
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
    
    func failedIMDBRating(with error: Error?) {
        print(error)
    }
}
