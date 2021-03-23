//
//  MainContainerViewController.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/17/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol MainContainerViewProtocol: AnyObject {
    var isStatusBarHidden: Bool { get set }
    var viewModel: MainContainerViewModelProtocol? { get set }
}

protocol MainContainerViewDelegate: AnyObject {
    func changeStatusBar(to hidden: Bool)
    func handleMenuClick()
    func changeMenuPanGesture(isEnable: Bool)
    func menuSelectionChanged(to type: MenuViewModel.MenuSideNavType)
}

class MainContainerViewController: ViewController, UIScrollViewDelegate {
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        changeContainerShadowPath()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
    }
    
    override func transition(isShow: Bool, isAnimate: Bool, completion: ((Bool) -> Void)? = nil) {
        mainNavController?.transition(isShow: isShow, isAnimate: isAnimate, completion: completion)
    }
    
    @objc func handleTapGesture() {
        handleMenuClick()
    }
    
    @objc func handleTapAboutMeGesture(_ gesture: UIPanGestureRecognizer) {
        let aboutMeReduceHeigh = (view.safeAreaInsets.top + view.safeAreaInsets.bottom + 24 * 2)
        let aboutMeScale = (view.frame.size.height - aboutMeReduceHeigh) / view.frame.size.height
        
        guard aboutMeContainerView.transform != CGAffineTransform(scaleX: aboutMeScale, y: aboutMeScale) else {
            animateMenuView(to: 1, isAnimate: true)
            
            tapGesture?.isEnabled = true
            menuController?.view.isUserInteractionEnabled = true
            changeMenuPanGesture(isEnable: true)
            aboutMeController?.animateMsgViews(isShow: false)
            aboutMeController?.memojiImgView.stopAnimating()
            return
        }
        
        changeMenuPanGesture(isEnable: false)
        menuController?.view.isUserInteractionEnabled = false
        tapGesture?.isEnabled = false
        aboutMeController?.animateMsgViews(isShow: true)
        aboutMeController?.memojiImgView.startAnimating()
        
        let mainReduceHeigh = (view.safeAreaInsets.top + view.safeAreaInsets.bottom + 24 * 2)
        let mainScale = (view.frame.size.height - mainReduceHeigh) / view.frame.size.height
        
        let mainViewTransform = CGAffineTransform(translationX: UIScreen.main.bounds.width + 60, y: 0).concatenating(CGAffineTransform(scaleX: mainScale, y: mainScale)).concatenating(CGAffineTransform(rotationAngle: (.pi/45)))
        
        UIView.easeSpringAnimation {
            self.aboutBlurView.alpha = 1
            self.aboutMeContainerView.transform = CGAffineTransform(scaleX: aboutMeScale, y: aboutMeScale)
            self.mainContainerView.transform = mainViewTransform
        }
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translationX = gesture.translation(in: nil).x
        let velocityX = gesture.velocity(in: nil).x
        
        switch gesture.state {
        case .cancelled, .ended:
            defer {
                animateMenuView(to: isMenuShowed ? 1 : 0)
            }
            
            let isNeedToChangeMenuState = velocityX.magnitude > 500 || translationX.magnitude >= view.frame.width / 3
            
            guard isNeedToChangeMenuState else { return }
            
            isMenuShowed = translationX >= 0
        default:
            var percentage = translationX.magnitude / Self.mainContainerTranlationRatio
            
            switch true {
            case isMenuShowed && translationX >= 0:
                percentage += 1
            case !isMenuShowed && translationX <= 0:
                percentage = 0
            case translationX < 0:
                percentage = 1 - percentage
            default:
                break
            }
            
            animateMenuView(to: max(0, percentage), isAnimate: false)
        }
    }
    
    private func initial() {
        setUpMenuView()
        setUpGestures()
        setUpMainView()
        setUpAboutMeView()
        animateMenuView(to: 0, isAnimate: false)
    }
    
    private func setUpGestures() {
        menuPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(menuPanGesture!)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tapGesture?.isEnabled = false
        view.addGestureRecognizer(tapGesture!)
    }
    
    private func setUpMenuView() {
        menuController = MenuViewModel.createModule(mainContainerDelegate: self) as? MenuViewController
        
        guard let menuController = menuController else { return }
        
        addChild(menuController)
        
        let mainContainerShadowPath = CGPath(roundedRect: view.bounds, cornerWidth: Self.containerViewsCornerRadius, cornerHeight: Self.containerViewsCornerRadius, transform: nil)
        mainContainerView.addAccentShadow(with: mainContainerShadowPath)
        mainContainerView.layer.cornerRadius = Self.containerViewsCornerRadius
        
        aboutMeContainerView.backgroundColor = UIColor.white
        aboutMeContainerView.layer.cornerRadius = Self.containerViewsCornerRadius
        aboutMeContainerView.addAccentShadow(with: mainContainerShadowPath)
        
        menuController.view.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(menuController.view, at: 0)
        menuController.didMove(toParent: self)
        
        menuController.view.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor).isActive = true
        menuController.view.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor).isActive = true
        menuController.view.topAnchor.constraint(equalTo: mainContainerView.topAnchor).isActive = true
        menuController.view.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor).isActive = true
    }
    
    private func setUpAboutMeView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapAboutMeGesture(_:)))
        aboutMeContainerView.addGestureRecognizer(tapGesture)
        
        aboutMeController = UIViewController.AboutMeViewController as? AboutMeViewController
        
        guard let aboutMeController = aboutMeController else { return }
        
        addChild(aboutMeController)
        
        aboutMeController.view.translatesAutoresizingMaskIntoConstraints = false
        aboutMeContainerView.addSubview(aboutMeController.view)
        aboutMeController.didMove(toParent: self)
        
        aboutMeController.view.leadingAnchor.constraint(equalTo: aboutMeContainerView.leadingAnchor).isActive = true
        aboutMeController.view.trailingAnchor.constraint(equalTo: aboutMeContainerView.trailingAnchor).isActive = true
        aboutMeController.view.topAnchor.constraint(equalTo: aboutMeContainerView.topAnchor).isActive = true
        aboutMeController.view.bottomAnchor.constraint(equalTo: aboutMeContainerView.bottomAnchor).isActive = true
        
        aboutBlurView.alpha = 0
        view.insertSubview(aboutBlurView, belowSubview: aboutMeContainerView)
        aboutBlurView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        aboutBlurView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        aboutBlurView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        aboutBlurView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setUpMainView() {
        mainNavController = MainViewModel.createModule(isIncludeNavigation: true, mainContainer: self) as? MainNavViewcontroller
        
        guard let mainNavController = mainNavController else { return }
        
        addChild(mainNavController)
        
        let mainContainerShadowPath = CGPath(roundedRect: view.bounds, cornerWidth: Self.containerViewsCornerRadius, cornerHeight: Self.containerViewsCornerRadius, transform: nil)
        mainContainerView.addAccentShadow(with: mainContainerShadowPath)
        mainContainerView.layer.cornerRadius = Self.containerViewsCornerRadius
        
        mainNavController.view.translatesAutoresizingMaskIntoConstraints = false
        mainContainerView.addSubview(mainNavController.view)
        mainNavController.didMove(toParent: self)
        
        mainNavController.view.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor).isActive = true
        mainNavController.view.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor).isActive = true
        mainNavController.view.topAnchor.constraint(equalTo: mainContainerView.topAnchor).isActive = true
        mainNavController.view.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor).isActive = true
    }
    
    private func changeContainerShadowPath() {
        let path = CGPath(roundedRect: view.bounds, cornerWidth: Self.containerViewsCornerRadius, cornerHeight: Self.containerViewsCornerRadius, transform: nil)
        mainContainerView.layer.shadowPath = path
        aboutMeContainerView.layer.shadowPath = path
    }
    
    private func animateMenuView(to percentage: CGFloat, isAnimate: Bool = true, completion: ((Bool)->Void)? = nil) {
        let isHide = percentage <= 0
        
        let mainReduceHeigh = (view.safeAreaInsets.top + view.safeAreaInsets.bottom + 24 * 2) * percentage
        let mainScale = (view.frame.size.height - mainReduceHeigh) / view.frame.size.height
        
        let mainViewTransform = isHide ? .identity : CGAffineTransform(translationX: Self.mainContainerTranlationRatio * percentage, y: 0).concatenating(CGAffineTransform(scaleX: mainScale, y: mainScale)).concatenating(CGAffineTransform(rotationAngle: (.pi/45) * percentage))
        
        let aboutMeReduceHeigh = (view.safeAreaInsets.top + view.safeAreaInsets.bottom + 48 * 2) * percentage
        let aboutMeScale = (view.frame.size.height - aboutMeReduceHeigh) / view.frame.size.height
        
        let reversePercentage = max(0,(1 - percentage))
        let menuScale = (view.frame.size.height + 96 * reversePercentage) / view.frame.size.height
        let menuTransform: CGAffineTransform = percentage != 1 ? CGAffineTransform(scaleX: menuScale, y: menuScale) : .identity
        
        UIView.easeSpringAnimation(
            isAnimate: isAnimate,
            usingSpringWithDamping: isHide ? 1 : 0.8, animations: {[weak self] in
                guard let self = self else { return }
                
                self.aboutBlurView.alpha = 0
                self.mainContainerView.transform = mainViewTransform
                self.aboutMeController?.view.layer.cornerRadius = isHide ? 0 : Self.containerViewsCornerRadius
                self.mainNavController?.view.layer.cornerRadius = isHide ? 0 : Self.containerViewsCornerRadius
                self.menuController?.view.transform = menuTransform
                self.aboutMeContainerView.transform = isHide ? .identity : CGAffineTransform(translationX: (Self.mainContainerTranlationRatio - 42) * percentage, y: 0).concatenating(CGAffineTransform(scaleX: aboutMeScale, y: aboutMeScale)).concatenating(CGAffineTransform(rotationAngle: (.pi/90) * percentage))
                
            }, completion: completion)
        
        changeStatusBar(to: percentage > 0)
    }
    
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var aboutMeContainerView: UIView!
    
    private let aboutBlurView: UIVisualEffectView = {
        let temp = UIVisualEffectView()
        temp.effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    static let containerViewsCornerRadius: CGFloat = 60
    static let mainContainerTranlationRatio: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) * 2.2 / 3
    
    var viewModel: MainContainerViewModelProtocol?
    var isStatusBarHidden: Bool = false
    
    private var menuPanGesture: UIPanGestureRecognizer?
    private var tapGesture: UITapGestureRecognizer?
    private var mainNavController: MainNavViewcontroller?
    private var menuController: MenuViewController?
    private var aboutMeController: AboutMeViewController?
    
    private var isMenuShowed: Bool = false {
        didSet {
            self.tapGesture?.isEnabled = isMenuShowed
            self.mainNavController?.view.isUserInteractionEnabled = !isMenuShowed
        }
    }
}

//  MARK: - VIEW_MODEL -> VIEW
extension MainContainerViewController: MainContainerViewProtocol {
    
}

//  MARK: - Main container view delegates.
extension MainContainerViewController: MainContainerViewDelegate {
    func changeStatusBar(to hidden: Bool) {
        guard isStatusBarHidden != hidden else { return }
        
        isStatusBarHidden = hidden
        UIView.easeSpringAnimation(withDuration: 0.3) {[weak self] in
            self?.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func handleMenuClick() {
        isMenuShowed.toggle()
        animateMenuView(to: isMenuShowed ? 1 : 0)
    }
    
    func changeMenuPanGesture(isEnable: Bool) {
        menuPanGesture?.isEnabled = isEnable
    }
    
    func menuSelectionChanged(to type: MenuViewModel.MenuSideNavType) {
        isMenuShowed = false
        
        animateMenuView(to: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {[weak self] in
            self?.viewModel?.handleNavSelection(for: type, view: self)
        }
    }
}
