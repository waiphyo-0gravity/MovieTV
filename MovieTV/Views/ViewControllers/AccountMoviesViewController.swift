//
//  AccountMoviesViewController.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/25/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit


protocol AccountMoviesViewProtocol: AnyObject {
    var viewModel: AccountMoviesViewModelProtocol? { get set }
    
    func handleAccountMoviesDataChanged()
}

class AccountMoviesViewController: ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statusBarHidableNavController?.changeStatusBar(isHidden: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.getAccountMovies()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func transition(isShow: Bool, isAnimate: Bool, completion: ((Bool) -> Void)? = nil) {
        rightCloseBtn.frame.origin.x = isShow ? 24 : 0
        rightCloseBtn.frame.origin.y = isShow ? -24 : 0
        
        UIView.easeSpringAnimation(isAnimate: isAnimate, withDuration: 0.3, animations: {[weak self] in
            self?.navigationController?.view.alpha = isShow ? 1 : 0
            self?.activityIndicatorView.transform = isShow ? .identity : .init(translationX: 0, y: 24)
            self?.accountMoviesCollectionView.transform = isShow ? .identity : .init(translationX: 0, y: 24)
            self?.navigationController?.navigationBar.transform = isShow ? .identity : .init(translationX: -24, y: 0)
            self?.rightCloseBtn.frame.origin.x = isShow ? 0 : 24
            self?.rightCloseBtn.frame.origin.y = isShow ? 0 : -24
        }, completion: completion)
    }
    
    @objc func handleRightNavBtnClicked() {
        dismiss(animated: true)
    }
    
    private func initial() {
        activityIndicatorView.startAnimating()
        accountMoviesCollectionView.customDelegate = self
        navigationSetUp()
    }
    
    private func navigationSetUp() {
        title = viewModel?.movieListType?.navigationTitle
        
        let rightSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        rightSpace.width = 16
        
        rightCloseBtn.addTarget(self, action: #selector(handleRightNavBtnClicked), for: .touchUpInside)
        let rightBtn = UIBarButtonItem(customView: rightCloseBtn)
        navigationItem.rightBarButtonItems = [rightSpace, rightBtn]
    }
    
    @IBOutlet weak var accountMoviesCollectionView: SearchCollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    let rightCloseBtn: MovieTVButton = {
        let temp = MovieTVButton(frame: .init(x: 0, y: 0, width: 40, height: 40))
        temp.layer.cornerRadius = 40 / 2
        temp.backgroundColor = .white
        temp.setImage(UIImage(named: "close_icon"), for: .normal)
        return temp
    }()
    
    private var statusBarHidableNavController: StatusBarHidableNavController? {
        return navigationController as? StatusBarHidableNavController
    }
    
    var viewModel: AccountMoviesViewModelProtocol?
}

//  MARK: - Collection view delegates.
extension AccountMoviesViewController: SearchCollectionViewDelegate {
    func handleSelectedMovie(at index: Int) {
        viewModel?.showMovieDetail(at: index, view: navigationController)
    }
    
    func reachPaging() {
        viewModel?.callAccountMovieListNextPage()
    }
}

//  MARK: - VIEW_MODEL -> VIEW
extension AccountMoviesViewController: AccountMoviesViewProtocol {
    func handleAccountMoviesDataChanged() {
        accountMoviesCollectionView.isPagingInclude = viewModel?.isMovieListIncludePaging == true
        accountMoviesCollectionView.data = viewModel?.accountMovies?.results ?? []
        activityIndicatorView.stopAnimating()
    }
}
