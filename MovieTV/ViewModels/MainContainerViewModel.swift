//
//  MainContainerViewModel.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/17/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol MainContainerViewModelProtocol {
    var view: MainContainerViewProtocol? { get set }
    
    func handleNavSelection(for type: MenuViewController.MenuSideNavType, view: UIViewController?)
}

class MainContainerViewModel: MainContainerViewModelProtocol {
    
    static func createModule() -> UIViewController? {
        guard let view = UIViewController.MainContainerViewController as? MainContainerViewController else { return nil }
        
        var viewModel: MainContainerViewModelProtocol = MainContainerViewModel()
        
        view.viewModel = viewModel
        viewModel.view = view
        return view
    }
    
    func handleNavSelection(for type: MenuViewController.MenuSideNavType, view: UIViewController?) {
        switch type {
        case .logout:
            
            let alertVC = AlertViewController(title: "Logout?", body: "Are you sure you want to log out?", alertType: .destructive, firstActionTitle: "Log out")
            let logoutBtn = AlertAction(title: "Log out", type: .destructive, handler: {[weak self] in
                self?.logout(for: view)
            })
            
            let cancelBtn = AlertAction(title: "Cancel", type: .cancel)
            
            alertVC.addAction(logoutBtn)
            alertVC.addAction(cancelBtn)
            view?.present(alertVC, animated: true)
        case .watchlist:
            showAccountMovielistView(view: view, type: .watchList)
        case .ratings:
            showAccountMovielistView(view: view, type: .ratedList)
        case .favorite:
            showAccountMovielistView(view: view, type: .favorite)
        }
    }
    
    private func logout(for view: UIViewController?) {
        guard let loginVC = LoginViewModel
                .createModule() else { return }
        
        UserDefaultsHelper.shared.sessionID = nil
        
        UIApplication.shared.firstKeyWindow?.rootViewController = loginVC
        UIApplication.shared.firstKeyWindow?.makeKeyAndVisible()
    }
    
    private func showAccountMovielistView(view: UIViewController?, type: AccountMoviesViewModel.MovieListType?) {
        guard let view = view, let watchListVC = AccountMoviesViewModel.createModule(movieListType: type) else { return }
        
        watchListVC.modalPresentationStyle = .fullScreen
        view.present(watchListVC, animated: true)
    }
    
    weak var view: MainContainerViewProtocol?
}
