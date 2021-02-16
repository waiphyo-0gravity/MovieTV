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
    
    func changedGenresList()
    func failedGenresList(with error: Error?)
    func changedMovieList()
    func failedMovieList(with error: Error?)
}

class MainNavViewcontroller: UINavigationController, UIGestureRecognizerDelegate {
    
    var isStatusBarHidden: Bool = false
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
}

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoad()
        initial()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainNavigationController?.isStatusBarHidden = false
        mainNavigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @objc func clickedMenuBtn(_ sender: UIButton) {
        UserDefaultsHelper.shared.sessionID = nil
        dismiss(animated: true)
    }
    
    @objc func clickedSearchBtn(_ sender: Any) {
        guard let loginVC = UIViewController.LoginViewController else { return }
        
        navigationController?.pushViewController(loginVC, animated: true)
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
        viewModel?.showMovieDetailVC(at: indexPath.row, from: self)
    }
}

//  MARK: - VIEW_MODEL -> VIEW
extension MainViewController: MainViewProtocol {
    func changedGenresList() {
        mainTableView.changeTagData(to: viewModel?.genres ?? [])
    }
    
    func changedMovieList() {
        mainTableView.movieListData = viewModel?.movieList?.results
    }
    
    func failedGenresList(with error: Error?) {
        print(error)
    }
    
    func failedMovieList(with error: Error?) {
        print(error)
    }
}
