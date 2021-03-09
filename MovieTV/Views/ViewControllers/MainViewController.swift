//
//  MainViewController.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/13/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol MainViewProtocol: NSObjectProtocol {
    var viewModel: MainViewModelProtocol? { get set }
    var mainContainer: MainContainerViewDelegate? { get set }
    
    func changedGenresList()
    func failedGenresList(with error: Error?)
    func changedMovieList()
    func failedMovieList(with error: Error?)
}

class MainNavViewcontroller: UINavigationController, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
}

class MainViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoad()
        initial()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainContainer?.changeStatusBar(to: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainContainer?.changeMenuPanGesture(isEnable: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainContainer?.changeMenuPanGesture(isEnable: false)
    }
    
    @objc func clickedMenuBtn(_ sender: UIButton) {
        mainContainer?.handleMenuClick()
    }
    
    @objc func clickedSearchBtn(_ sender: UIButton) {
        viewModel?.showSearchVC(from: self)
    }
    
    private func initial() {
        tableView.customDelegate = self
        mainNavItem?.menuBtn.addTarget(self, action: #selector(clickedMenuBtn(_:)), for: .touchUpInside)
        mainNavItem?.searchBtn.addTarget(self, action: #selector(clickedSearchBtn(_:)), for: .touchUpInside)
    }
    
    @IBOutlet weak var mainTableView: MainTableView!
    @IBOutlet weak var tableView: MainTableView!
    
    var mainNavItem: MainNavigationItem? {
        return navigationItem as? MainNavigationItem
    }
    
    var mainNavigationController: MainNavViewcontroller? {
        return navigationController as? MainNavViewcontroller
    }
    
    var viewModel: MainViewModelProtocol?
    weak var mainContainer: MainContainerViewDelegate?
}

//  MARK: - Main table custom delegates.
extension MainViewController: MainTableViewDelegate {
    func changedMovieType(to type: MainViewModel.MovieListType) {
        viewModel?.movieListType = type
    }
    
    func changedTagSelection(at index: Int) {
        viewModel?.changedTagSelection(at: index)
    }
    
    func choosedMovie(at indexPath: IndexPath) {
        viewModel?.showMovieDetailVC(at: indexPath.row, from: self, mainContainer: mainContainer)
    }
    
    func reachPaging() {
        viewModel?.callMovieListNextPage()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

//  MARK: - VIEW_MODEL -> VIEW
extension MainViewController: MainViewProtocol {
    func changedGenresList() {
        mainTableView.changeTagData(to: viewModel?.genres ?? [])
    }
    
    func changedMovieList() {
        mainTableView.isPagingInclude = viewModel?.isMovieListIncludePaging == true
        print(viewModel?.movieList?.results.count, "huhuhu")
        mainTableView.movieListData = viewModel?.movieList?.results
    }
    
    func failedGenresList(with error: Error?) {
        print(error)
    }
    
    func failedMovieList(with error: Error?) {
        print(error)
    }
}
