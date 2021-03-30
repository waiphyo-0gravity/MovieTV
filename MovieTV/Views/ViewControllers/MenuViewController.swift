//
//  MenuViewController.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/20/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit
import Lottie

protocol MenuViewProtocol: AnyObject {
    var viewModel: MenuViewModelProtocol? { get set }
    var mainContainerDelegate: MainContainerViewDelegate? { get set }
    
    func handleDisplayNameChanged()
}

protocol MenuViewControllerDelegate: AnyObject {
    func changeProfileAnimation(isShow: Bool)
}

class MenuViewController: ViewController, MenuViewControllerDelegate {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setUpConstraint(with: size)
        
        coordinator.animate {[weak self] _ in
            self?.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoad()
        initial()
    }
    
    @IBAction func clickedLogoutBtn(_ sender: Any) {
        mainContainerDelegate?.menuSelectionChanged(to: MenuViewModel.MenuSideNavType.logout)
    }
    
    @IBAction func clickedProfileView(_ sender: Any) {
        profileContainerView.transform = .identity
        let touchedViewFrame = menuTopView.convert(profileContainerView.frame, to: nil)
        viewModel?.showProfileChooser(from: self, touchedViewFrame: touchedViewFrame, displayedName: displayNameLbl.text)
    }
    
    private func initial() {
        setUpConstraint()
        tableViewSetUp()
        setUpProfileView()
    }
    
    func changeProfileAnimation(isShow: Bool) {
        guard (isShow && !profileLottieView.isAnimationPlaying) || (!isShow && profileLottieView.isAnimationPlaying) else { return }
        
        switch true {
        case isShow && !profileLottieView.isAnimationPlaying:
            profileLottieView.play()
        case !isShow && profileLottieView.isAnimationPlaying:
            profileLottieView.pause()
        default:
            break
        }
    }
    
    private func setUpProfileView() {
        profileLottieView.loopMode = .loop
        profileContainerView.addAccentShadow(with: .init(rect: profileContainerView.bounds, transform: nil))
        
        if let avatar = viewModel?.avatarName {
            profileLottieView.changeAnimation(with: avatar, autoPlay: false)
        }
        
        profileEditActionBtn.specificAnimateView = profileContainerView
        
        handleDisplayNameChanged()
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
    @IBOutlet weak var menuTopView: MovieDetailRatingView!
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var profileLottieView: AnimationView!
    @IBOutlet weak var profileEditActionBtn: MovieTVButton!
    @IBOutlet weak var displayNameLbl: UILabel!
    
    var viewModel: MenuViewModelProtocol?
    weak var mainContainerDelegate: MainContainerViewDelegate?
}

//  MARK: - Table view delegates.
extension MenuViewController: UITableViewDataSource, UITableViewDelegate, MenuSideNavTableViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuViewModel.MenuSideNavType.navListType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menusidenavtableviewcell", for: indexPath) as? MenuSideNavTableViewCell else { return UITableViewCell() }
        
        let currentData = MenuViewModel.MenuSideNavType.navListType[indexPath.row].data
        
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
        
        mainContainerDelegate?.menuSelectionChanged(to: MenuViewModel.MenuSideNavType.navListType[indexPath.row])
    }
}

//  MARK: - VIEW_MODEL -> VIEW
extension MenuViewController: MenuViewProtocol {
    func handleDisplayNameChanged() {
        displayNameLbl.text = "Hi \(viewModel?.displayName ?? "")!"
    }
}

//  MARK: - Profile chooser delegates.
extension MenuViewController: ProfileChooserViewDelegate {
    func handleAvatarChanging() {
        guard let avatar = viewModel?.avatarName else { return }
        
        profileLottieView.animation = nil
        profileLottieView.changeAnimation(with: avatar, autoPlay: false)
    }
    
    func animateAvatarView() {
        profileLottieView.play()
    }
}
