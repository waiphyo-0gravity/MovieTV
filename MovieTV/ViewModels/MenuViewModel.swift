//
//  MenuViewModel.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/20/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol MenuViewModelProtocol {
    var view: MenuViewProtocol? { get set }
    
    func getMainContainerTranslationRatio(with specificSize: CGSize?) -> CGFloat?
}

class MenuViewModel: MenuViewModelProtocol {
    
    static func createModule(mainContainerDelegate: MainContainerViewDelegate?) -> UIViewController? {
        guard let view = UIViewController.MenuViewController as? MenuViewController else { return nil }
        
        var viewModel: MenuViewModelProtocol = MenuViewModel()
        
        view.mainContainerDelegate = mainContainerDelegate
        view.viewModel = viewModel
        viewModel.view = view
        return view
    }
    
    func getMainContainerTranslationRatio(with specificSize: CGSize? = nil) -> CGFloat? {
        guard let specificSize = specificSize else { return mainContainerTranlationRatio }
        
        return ((specificSize.width * 2.2) / 3) - 42
    }
    
    enum MenuSideNavType: CaseIterable {
        case ratings, watchlist, favorite, logout
        
        static var navListType: [MenuSideNavType] {
            return UserDefaultsHelper.shared.mappedUserType == .normal ? [.favorite, .watchlist, .ratings] : [.ratings]
        }
        
        var data: (title: String?, img: UIImage?, imgTinColor: UIColor?) {
            switch self {
            case .ratings:
                return ("Ratings", UIImage(named: "star_fill_icon"), .systemOrange)
            case .watchlist:
                return ("Watchlist", UIImage(named: "watchlist_fill_icon"), .R100)
            case .favorite:
                return ("Favorite", UIImage(named: "favorite_fill_icon"), .P300)
            default:
                return (nil, nil, nil)
            }
        }
    }
    
    weak var view: MenuViewProtocol?
    private var mainContainerTranlationRatio: CGFloat? { MainContainerViewController.mainContainerTranlationRatio - 42 }
}
