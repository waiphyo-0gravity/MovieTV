//
//  MenuViewController.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/20/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol MenuViewProtocol: AnyObject {
    var viewModel: MenuViewModelProtocol? { get set }
    var mainContainerDelegate: MainContainerViewDelegate? { get set }
}

class MenuViewController: ViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setUpConstraint(with: size)
        
        coordinator.animate {[weak self] _ in
            self?.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
    }
    
    @IBAction func clickedLogoutBtn(_ sender: Any) {
        mainContainerDelegate?.menuSelectionChanged(to: .logout)
    }
    
    private func initial() {
        setUpConstraint()
        tableViewSetUp()
    }
    
    private func setUpConstraint(with specificView: CGSize? = nil) {
        logoutBtn.layer.cornerRadius = 64 / 2
        logoutBtn.addAccentShadow(with: .init(roundedRect: logoutBtn.frame, cornerWidth: 64/2, cornerHeight: 64/2, transform: nil))
        
        guard let mainContainerTranlationRatio = viewModel?.getMainContainerTranslationRatio(with: specificView) else { return }
        
        tableViewTrailingConstraint.constant = mainContainerTranlationRatio
    }
    
    private func tableViewSetUp() {
        tableView.contentInset = .init(top: 260, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    @IBOutlet weak var topViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutBtn: MovieTVButton!
    
    var viewModel: MenuViewModelProtocol?
    weak var mainContainerDelegate: MainContainerViewDelegate?
    
    enum MenuSideNavType: CaseIterable {
        case ratings, watchlist, favorite, logout
        
        static var navListType: [MenuSideNavType] {
            return [.favorite, .watchlist, .ratings]
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
}

//  MARK: - Table view delegates.
extension MenuViewController: UITableViewDataSource, UITableViewDelegate, MenuSideNavTableViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuSideNavType.navListType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menusidenavtableviewcell", for: indexPath) as? MenuSideNavTableViewCell else { return UITableViewCell() }
        
        let currentData = MenuSideNavType.navListType[indexPath.row].data
        
        cell.navTitleLbl.text = currentData.title
        cell.imgView.image = currentData.img
        cell.imgView.tintColor = currentData.imgTinColor
        cell.delegate = self
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newTopViewBottomConstraint = scrollView.contentOffset.y + 260
        
        topViewBottomConstraint.constant = max(22, 260 - newTopViewBottomConstraint)
    }
    
    func handleSideNavSelection(for cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        mainContainerDelegate?.menuSelectionChanged(to: MenuSideNavType.navListType[indexPath.row])
    }
}

//  MARK: - VIEW_MODEL -> VIEW
extension MenuViewController: MenuViewProtocol {
    
}
