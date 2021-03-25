//
//  MainTopMediaScrollView.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/16/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

protocol MainTopMediaScrollViewDelegate: AnyObject {
    func mainScrollViewDidScroll(scrollView: UIScrollView)
}

class MainTopMediaScrollView: FlexableCornerRadiusView {
    deinit {
        animator.stopAnimation(true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeHideActionViewDispatchWorkItem()
    }
    
    func setBackgroundBlurViewAlpha(to percentage: CGFloat) {
        bgBlurView.alpha = percentage
    }
    
    static func makeActionBtn(with imgName: String) -> (UIVisualEffectView, MovieTVButton) {
        let temp = UIVisualEffectView()
        temp.effect = UIBlurEffect()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.widthAnchor.constraint(equalToConstant: 40).isActive = true
        temp.heightAnchor.constraint(equalToConstant: 40).isActive = true
        temp.clipsToBounds = true
        temp.layer.cornerRadius = 12
        
        let actionBtn = MovieTVButton()
        actionBtn.specificAnimateView = temp
        actionBtn.setImage(UIImage(named: imgName), for: .normal)
        actionBtn.tintColor = UIColor.white.withAlphaComponent(0.8)
        actionBtn.translatesAutoresizingMaskIntoConstraints = false
        temp.contentView.addSubview(actionBtn)
        actionBtn.leadingAnchor.constraint(equalTo: temp.contentView.leadingAnchor).isActive = true
        actionBtn.trailingAnchor.constraint(equalTo: temp.contentView.trailingAnchor).isActive = true
        actionBtn.bottomAnchor.constraint(equalTo: temp.contentView.bottomAnchor).isActive = true
        actionBtn.topAnchor.constraint(equalTo: temp.contentView.topAnchor).isActive = true

        return (temp, actionBtn)
    }
    
    @objc func handleClickedActionBtn(_ sender: UIButton) {
        makeHideActionViewDispatchWorkItem()
        
        let currentIndex = ceil(scrollView.contentOffset.x / frame.width) + (sender.tag == 0 ? -1 : 1)
        
        guard currentIndex >= 0 && currentIndex <= CGFloat(youtubePlayerViews.count) else { return }
        
        let newScrollFrame = currentIndex * frame.width
        
        scrollView.setContentOffset(.init(x: newScrollFrame, y: 0), animated: true)
    }
    
    @objc func handleTappedView() {
        clearDispatchWorkItem()
        
        let isShowActionView = actionView.alpha == 0
        
        animateActionView(isShow: isShowActionView)
        
        guard isShowActionView else { return }
        
        makeHideActionViewDispatchWorkItem()
    }
    
    private func initial() {
        cornerRadiusData = ([UIRectCorner.bottomLeft], 38)
        addScrollView()
        addStackView()
        addImgView()
        addActionView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTappedView))
        addGestureRecognizer(tapGesture)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {[weak self] in
            self?.makeHideActionViewDispatchWorkItem()
        }
    }
    
    private func addScrollView() {
        scrollView.delegate = self
        addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func addStackView() {
        scrollView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    private func addImgView() {
        stackView.addArrangedSubview(movieCoverImgView)
        movieCoverImgView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        movieCoverImgView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    private func addActionView() {
        addSubview(actionView)
        actionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        actionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        actionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        actionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        actionView.addSubview(leftActionBtn)
        leftActionBtn.leadingAnchor.constraint(equalTo: actionView.leadingAnchor, constant: 26).isActive = true
        leftActionBtn.centerYAnchor.constraint(equalTo: actionView.centerYAnchor).isActive = true
        
        actionView.addSubview(rightActionBtn)
        rightActionBtn.trailingAnchor.constraint(equalTo: actionView.trailingAnchor, constant: -26).isActive = true
        rightActionBtn.centerYAnchor.constraint(equalTo: actionView.centerYAnchor).isActive = true
        
        bgBlurView.alpha = 0
        addSubview(bgBlurView)
        bgBlurView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bgBlurView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bgBlurView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bgBlurView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        animator.addAnimations {[weak self] in
            let btnBlurEffect: UIBlurEffect
            let bgBlurEffect: UIBlurEffect
            
            if #available(iOS 13.0, *) {
                btnBlurEffect = UIBlurEffect(style: .systemThickMaterialLight)
                bgBlurEffect = UIBlurEffect(style: .systemThickMaterialDark)
            } else {
                btnBlurEffect = UIBlurEffect(style: .light)
                bgBlurEffect = UIBlurEffect(style: .dark)
            }
            
            self?.leftActionBtn.effect = btnBlurEffect
            self?.rightActionBtn.effect = btnBlurEffect
            self?.bgBlurView.effect = bgBlurEffect
        }
        
        animator.fractionComplete = 0.2
    }
    
    private func handleTrailerModelChanged() {
        guard var trailers = data?.results else { return }
        
        trailers = Array(trailers[0..<min(3, trailers.count)])
        
        youtubePlayerViews =  trailers.compactMap { trailer in
            guard let id = trailer.key else { return nil }
            
            let player = YTPlayerView()
            player.load(withVideoId: id, playerVars: [
                "playsinline": 1,
                "controls": 1,
            ])
            
            stackView.addArrangedSubview(player)
            player.translatesAutoresizingMaskIntoConstraints = false
            player.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            player.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
            
            return player
        }
        
        animateActionView(isShow: true)
        makeHideActionViewDispatchWorkItem()
        animateLeftActionBtn()
        animateRightActionBtn()
    }
    
    private func clearDispatchWorkItem() {
        dispatchWorkItem?.cancel()
        dispatchWorkItem = nil
    }
    
    private func makeHideActionViewDispatchWorkItem() {
        dispatchWorkItem?.cancel()
        
        dispatchWorkItem = DispatchWorkItem {[weak self] in
            self?.animateActionView(isShow: false)
            self?.dispatchWorkItem = nil
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: dispatchWorkItem!)
    }
    
    private func animateActionView(isShow: Bool, isAnimate: Bool = true) {
        guard (isShow && actionView.alpha == 0) || (!isShow && actionView.alpha == 1) else { return }
        
        UIView.easeSpringAnimation(isAnimate: isAnimate) {[weak self] in
            self?.actionView.alpha = isShow ? 1 : 0
            self?.leftActionBtn.transform = isShow && self?.isActionBtnsShow.leftBtn == true ? .identity : CGAffineTransform(translationX: -24, y: 0)
            self?.rightActionBtn.transform = isShow && self?.isActionBtnsShow.rightBtn == true ? .identity : CGAffineTransform(translationX: 24, y: 0)
        }
    }
    
    private func animateLeftActionBtn(isAnimate: Bool = true) {
        let isShow = isActionBtnsShow.leftBtn
        
        guard (isShow && leftActionBtn.alpha == 0) || (!isShow && leftActionBtn.alpha == 1) else { return }
        
        UIView.easeSpringAnimation {[weak self] in
            self?.leftActionBtn.alpha = isShow ? 1 : 0
            self?.leftActionBtn.transform = isShow ? .identity : CGAffineTransform(translationX: -24, y: 0)
        }
    }
    
    private func animateRightActionBtn(isAnimate: Bool = true) {
        let isShow = isActionBtnsShow.rightBtn
        
        guard (isShow && rightActionBtn.alpha == 0) || (!isShow && rightActionBtn.alpha == 1) else { return }
        
        UIView.easeSpringAnimation {[weak self] in
            self?.rightActionBtn.alpha = isShow ? 1 : 0
            self?.rightActionBtn.transform = isShow ? .identity : CGAffineTransform(translationX: 24, y: 0)
        }
    }
    
    private let scrollView: UIScrollView = {
        let temp = UIScrollView()
        temp.isPagingEnabled = true
        temp.backgroundColor = .clear
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    private let stackView: UIStackView = {
        let temp = UIStackView()
        temp.distribution = .fillEqually
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    let movieCoverImgView: UIImageView = {
        let temp = UIImageView()
        temp.contentMode = .scaleAspectFill
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    let actionView: MainTopMediaActionView = {
        let temp = MainTopMediaActionView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    let bgBlurView: UIVisualEffectView = {
        let temp = UIVisualEffectView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    let leftActionBtn: UIVisualEffectView = {
        let (temp, actionBtn) = makeActionBtn(with: "back_icon")
        actionBtn.tag = 0
        actionBtn.addTarget(self, action: #selector(handleClickedActionBtn(_:)), for: .touchUpInside)
        return temp
    }()
    
    let rightActionBtn: UIVisualEffectView = {
        let (temp, actionBtn) = makeActionBtn(with: "next_icon")
        actionBtn.tag = 1
        actionBtn.addTarget(self, action: #selector(handleClickedActionBtn(_:)), for: .touchUpInside)
        return temp
    }()
    
    weak var customDelegate: MainTopMediaScrollViewDelegate?
    
    var data: MovieTrailerModel? {
        didSet {
            handleTrailerModelChanged()
        }
    }
    
    private var youtubePlayerViews: [YTPlayerView] = []
    private let animator = UIViewPropertyAnimator(duration: 1, curve: .linear)
    private var dispatchWorkItem: DispatchWorkItem?
    
    private var isActionBtnsShow: (leftBtn: Bool, rightBtn: Bool) {
        let currentIndex = max(0, scrollView.contentOffset.x) / frame.width
        let rightBtnCondition = ceil(currentIndex) < CGFloat(youtubePlayerViews.count)
        
        return (floor(currentIndex) > 0, rightBtnCondition)
    }
}

//  MARK: - Scroll view delegates.
extension MainTopMediaScrollView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customDelegate?.mainScrollViewDidScroll(scrollView: scrollView)
        clearDispatchWorkItem()
        animateActionView(isShow: true)
        animateLeftActionBtn()
        animateRightActionBtn()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        handleScrollEnd()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        handleScrollEnd()
    }
    
    private func handleScrollEnd() {
        let currentPage = round(scrollView.contentOffset.x / frame.width) - 1
        
        if currentPage >= 0 {
            youtubePlayerViews[Int(currentPage)].playVideo()
        }
        
        youtubePlayerViews.enumerated().forEach { player in
            if CGFloat(player.offset) != currentPage {
                player.element.stopVideo()
            }
        }
        
        makeHideActionViewDispatchWorkItem()
    }
}

internal class MainTopMediaActionView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view != self ? view : nil
    }
}
