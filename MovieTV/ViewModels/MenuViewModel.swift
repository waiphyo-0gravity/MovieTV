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
    var accountWebService: AccountWebServiceInputProtocol? { get set }
    var avatarName: String? { get }
    var displayName: String? { get set }
    var mappedUserType: UserDefaultsHelper.UserType? { get }
    
    func viewDidLoad()
    func getMainContainerTranslationRatio(with specificSize: CGSize?) -> CGFloat?
    func showProfileChooser(from vc: (UIViewController & ProfileChooserViewDelegate)?, touchedViewFrame: CGRect, displayedName: String?)
}

class MenuViewModel: MenuViewModelProtocol {
    static func createModule(mainContainerDelegate: MainContainerViewDelegate?) -> UIViewController? {
        guard let view = UIViewController.MenuViewController as? MenuViewController else { return nil }
        
        var viewModel: MenuViewModelProtocol & AccountWebServiceOutputProtocol = MenuViewModel()
        var acountWebService: AccountWebServiceInputProtocol = AccountWebService()
        
        view.mainContainerDelegate = mainContainerDelegate
        view.viewModel = viewModel
        viewModel.view = view
        viewModel.accountWebService = acountWebService
        acountWebService.viewModel = viewModel
        
        return view
    }
    
    func viewDidLoad() {
        if mappedUserType == .guest {
            displayName = "Guest"
            accountWebService?.getAccountMovieList(for: .ratedList, page: 1)
        } else {
            accountWebService?.getAccountDetail()
        }
    }
    
    func getMainContainerTranslationRatio(with specificSize: CGSize? = nil) -> CGFloat? {
        guard let specificSize = specificSize else { return mainContainerTranlationRatio }
        
        return ((specificSize.width * 2.2) / 3) - 42
    }
    
    func showProfileChooser(from vc: (UIViewController & ProfileChooserViewDelegate)?, touchedViewFrame: CGRect, displayedName: String?) {
        guard let fromVC = vc,
              let movieDetailVC = ProfileChooserViewModel.createModule(delegate: vc, touchedFrame: touchedViewFrame, displayedName: displayedName) else { return }
        
        movieDetailVC.modalPresentationStyle = .overFullScreen
        fromVC.present(movieDetailVC, animated: false)
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
    
    var accountWebService: AccountWebServiceInputProtocol?
    var avatarName: String? { UserDefaultsHelper.shared.avatarName }
    var mappedUserType: UserDefaultsHelper.UserType? { UserDefaultsHelper.shared.mappedUserType }
    
    var displayName: String? {
        get {
            return UserDefaultsHelper.shared.userName
        }
        
        set {
            UserDefaultsHelper.shared.userName = newValue
        }
    }
    
    private var mainContainerTranlationRatio: CGFloat? { MainContainerViewController.mainContainerTranlationRatio - 42 }
}

//  MARK: - WEB_SERVICE -> VIEW_MODEL
extension MenuViewModel: AccountWebServiceOutputProtocol {
    func responseFromAccountDetail(isSuccess: Bool, data: AccountDetailModel?, error: Error?) {
        guard isSuccess,
              let data = data else { return }
        
        let name = data.name?.isEmpty == false ? data.name : data.username ?? nil
        
        guard displayName != name else { return }
        
        displayName = name
        
        view?.handleDisplayNameChanged()
    }
}
