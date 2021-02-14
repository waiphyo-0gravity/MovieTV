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
    }
    
    private func setUpTopViews() {
        let url = URLHelper.Image.customWidth(500, viewModel?.data?.posterPath).urlStr
        movieCoverImgView.setImg(url: url)
        movieCoverImgView.cornerRadiusData = ([UIRectCorner.bottomLeft], 38)
        movieNavItem?.leftBackBtn.addTarget(self, action: #selector(clickedNavBack), for: .touchUpInside)
        mainNavigationController?.isStatusBarHidden = true
        mainNavigationController?.setNeedsStatusBarAppearanceUpdate()
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
        
        ratingRatioLbl.text = "\(data?.voteAverage ?? 0.0)/\(10)"
        ratingCountLbl.text = "\(data?.voteCount ?? 0)"
    }
    
    @IBOutlet weak var movieCoverImgView: FlexableCornerRadiusImgView!
    @IBOutlet weak var movieDetailTableView: MovieDetailTableView!
    @IBOutlet weak var movieCoverImgViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var ratingContainerView: UIView!
    @IBOutlet weak var ratingRatioLbl: UILabel!
    @IBOutlet weak var ratingCountLbl: UILabel!
    @IBOutlet weak var ratingBtn: MovieTVButton!
    
    var movieNavItem: MovieDetailNavigationItem? {
        return navigationItem as? MovieDetailNavigationItem
    }
    
    var mainNavigationController: MainNavViewcontroller? {
        return navigationController as? MainNavViewcontroller
    }
    
    static let coverBottomConstant: CGFloat = 256
    
    var viewModel: MovieDetailViewModelProtocol?
}

//  MARK: - Movie table view custom delegates.
extension MovieDetailViewController: MovieDetailTableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let actualContentOffsetY = scrollView.contentOffset.y + movieDetailTableView.contentInset.top
        
        movieCoverImgViewBottomConstraint.constant = max(52, Self.coverBottomConstant - actualContentOffsetY)
    }
}

//  MARK: - VIEW_MODEL -> VIEW
extension MovieDetailViewController: MovieDetailViewProtocol {
    func handleMovieDetailChanged() {
        movieDetailTableView.movieDetailData = viewModel?.movieDetailData
    }
}
