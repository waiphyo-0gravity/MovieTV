//
//  SearchViewController.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/23/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit
import Lottie

protocol SearchViewProtocol: AnyObject {
    var viewModel: SearchViewModelProtocol? { get set }
    
    func handleSearchedMoviesChanged()
}

class StatusBarHidableNavController: MainNavViewcontroller {
    private var isStatusBarHidden: Bool = false
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: UIFont.FontStyle.bold.rawValue, size: 34)!,
            NSAttributedString.Key.foregroundColor: UIColor.C300
        ]
        
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.h4_strong!
        ]
    }
    
    func changeStatusBar(isHidden: Bool) {
        isStatusBarHidden = isHidden
        
        UIView.easeSpringAnimation(withDuration: 0.3) {[weak self] in
            self?.setNeedsStatusBarAppearanceUpdate()
        }
    }
}

class SearchViewController: ViewController {
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
        viewModel?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchNavController?.changeStatusBar(isHidden: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        searchTxtField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func transition(isShow: Bool, isAnimate: Bool, completion: ((Bool) -> Void)? = nil) {
        UIView.easeSpringAnimation(isAnimate: isAnimate, withDuration: 0.3, animations: {[weak self] in
            self?.view.alpha = isShow ? 1 : 0
            self?.navigationController?.view.alpha = isShow ? 1 : 0
            self?.searchNavController?.navigationBar.transform = isShow ? .identity : .init(translationX: 0, y: -24)
            self?.searchContainerView.transform = isShow ? .identity : .init(translationX: -24, y: 0)
            self?.cancelBtn.transform = isShow ? .identity : .init(translationX: 24, y: 0)
            self?.searchCountLbl.transform = isShow ? .identity : .init(translationX: 0, y: 24)
            self?.lottieView.transform = isShow ? .identity : .init(translationX: 0, y: 24)
            self?.searchCollectionView.transform = isShow ? .identity : .init(translationX: 0, y: 24)
        }, completion: completion)
    }
    
    @IBAction func clickedCancelBtn(_ sender: Any) {
        view.endEditing(true)
        dismiss(animated: true)
    }
    
    @objc func handleKeyboard(_ notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        switch notification.name {
        case UIResponder.keyboardWillShowNotification:
            view.frame.size.height = UIScreen.main.bounds.height - keyboardSize.height
        case UIResponder.keyboardWillHideNotification:
            view.frame.size.height = UIScreen.main.bounds.height
        default: break
        }
        
        view.layoutIfNeeded()
    }
    
    @objc func handleTxtFieldChanged() {
        animateSearchImgContainer(isSearching: true)
        animateLottieAnimationView(isShow: searchTxtField.text?.isEmpty != false)
        viewModel?.search(for: searchTxtField.text)
    }
    
    private func initial() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        view.touchAroundToHideKeyboard()
        setUpSearchTxtField()
        handleDataChanged()
        searchCollectionView.customDelegate = self
        
        lottieView.loopMode = .loop
        
        if let lottieAnimateFileName = viewModel?.searchLottieAnimationName {
            lottieView.changeAnimation(with: lottieAnimateFileName)
        }
    }
    
    private func setUpSearchTxtField() {
        searchTxtField.delegate = self
        searchTxtField.returnKeyType = .search
        searchTxtField.enablesReturnKeyAutomatically = true
        searchTxtField.addTarget(self, action: #selector(handleTxtFieldChanged), for: UIControl.Event.editingChanged)
        searchContainerView.layer.cornerRadius = 8
        searchContainerView.addAccentShadow()
        animateSearchImgContainer(isSearching: false, isAnimate: false)
    }
    
    private func handleDataChanged() {
        let totalResult = viewModel?.searchedMovies?.totalResults
        searchCountLbl.alpha = totalResult == nil ? 0 : 1
        searchCountLbl.text = "\(totalResult ?? 0) movie\(totalResult ?? 0 > 1 ? "s" : "")"
    }
    
    private func animateSearchContainerShadow(isSelected: Bool) {
        searchContainerView.layer.removeAllAnimations()
        let animation = CABasicAnimation(keyPath: "shadowColor")
        animation.fromValue = isSelected ? UIColor.black.withAlphaComponent(0.08).cgColor : UIColor.black.withAlphaComponent(0.2).cgColor
        animation.toValue = isSelected ? UIColor.black.withAlphaComponent(0.2).cgColor : UIColor.black.withAlphaComponent(0.08).cgColor
        animation.duration = 0.5
        animation.isRemovedOnCompletion = false
        animation.fillMode = .both
        searchContainerView.layer.add(animation, forKey: "shadowcolor")
    }
    
    private func animateSearchImgContainer(isSearching: Bool, isAnimate: Bool = true, complection: ((Bool)->Void)? = nil) {
        
        guard (isSearching && searchImgView.alpha == 1) || (!isSearching && searchImgView.alpha == 0) else { return }
        
        if isSearching {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
        
        searchImgView.alpha = isSearching ? 0 : 1
        activityIndicatorView.alpha = isSearching ? 1 : 0
    }
    
    private func animateLottieAnimationView(isShow: Bool, isAnimate: Bool = true) {
        guard (isShow && lottieView.alpha == 0) || (!isShow && lottieView.alpha == 1) else { return }
        
        if isShow {
            lottieView.play()
        } else {
            lottieView.pause()
        }
        
        UIView.easeSpringAnimation(isAnimate: isAnimate) {[weak self] in
            self?.lottieView.alpha = isShow ? 1 : 0
            self?.lottieView.transform = isShow ? .identity : .init(scaleX: 0.8, y: 0.8)
        }
    }
    
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchTxtField: UITextField!
    @IBOutlet weak var searchImgContainerView: UIView!
    @IBOutlet weak var searchImgView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var searchCollectionView: SearchCollectionView!
    @IBOutlet weak var topViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchCountLbl: UILabel!
    @IBOutlet weak var cancelBtn: MovieTVButton!
    @IBOutlet weak var lottieView: AnimationView!
    
    private var searchNavController: StatusBarHidableNavController? {
        return navigationController as? StatusBarHidableNavController
    }
    
    var viewModel: SearchViewModelProtocol?
}

//  MARK: - Search collection view delegates.
extension SearchViewController: SearchCollectionViewDelegate {
    func handleSelectedMovie(at index: Int) {
        view.endEditing(true)
        viewModel?.showMovieDetail(at: index, view: navigationController)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newConstant = max(103, 103 - scrollView.contentOffset.y - scrollView.contentInset.top)
        topViewBottomConstraint.constant = newConstant
    }
    
    func reachPaging() {
        viewModel?.callSearchMovieListNextPage(for: searchTxtField.text)
    }
}

//  MARK: - Text field delegates.
extension SearchViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateSearchContainerShadow(isSelected: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        animateSearchContainerShadow(isSelected: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}


//  MARK: - VIEW_MODEL -> VIEW
extension SearchViewController: SearchViewProtocol {
    func handleSearchedMoviesChanged() {
        animateSearchImgContainer(isSearching: false)
        searchCollectionView.isPagingInclude = viewModel?.isMovieListIncludePaging == true
        searchCollectionView.data = viewModel?.searchedMovies?.results ?? []
        handleDataChanged()
    }
}
