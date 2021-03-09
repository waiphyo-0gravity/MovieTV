//
//  RatingViewController.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/28/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol RatingViewControllerDelegate: AnyObject {
    func handleRatingChanged(rating: Float)
}

class RatingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
    }
    
    @IBAction func clickedIncreaseBtn(_ sender: Any) {
        let newRatings = min(5, currentRating + 0.5)
        
        changeCurrentRating(to: newRatings)
        incrementRatings(newRating: newRatings)
        startCountLbl.bounceAnimation()
    }
    
    @IBAction func clickedReduceBtn(_ sender: Any) {
        let newRatings = max(0, currentRating - 0.5)
        
        changeCurrentRating(to: newRatings)
        incrementRatings(newRating: newRatings)
        startCountLbl.bounceAnimation()
    }
    
    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: stackView)
        
        let re = min(5, max(0,location.x / (starWidth + stackViewSpacing)))
        let percentage = re - floor(re)
        
        let currentStar = floor(re)
        
        switch sender.state {
        case .began, .changed:
            let extraStar: CGFloat = percentage < 0.3 ? 0 : (percentage >= 0.6 ? 1 : 0.5)
            let actualStar = currentStar + extraStar
            let starCount = Float(actualStar)
            
            changeStarCount(to: starCount)
            animateRatingProgressView(to: location.x)
            
            if sender.state == .began {
                animateStarCountLbl(isLarge: true)
            }
        case .ended, .cancelled:
            let extraStar: CGFloat = percentage > 0.3 ? 1 : (percentage <= 0 ? 0 : 0.5)
            let actualStar = currentStar + extraStar
            let starCount = Float(actualStar)
            
            let collaspedLocation = (actualStar * starWidth) + (currentStar * stackViewSpacing)
            changeCurrentRating(to: starCount)
            changeStarCount(to: starCount)
            animateRatingProgressView(to: collaspedLocation)
            animateStarCountLbl(isLarge: false)
        default:
            break
        }
    }
    
    @objc func handleTapRating(_ sender: UIButton, forEvent event: UIEvent) {
        let touch = event.touches(for: sender)?.first
        let locationX = touch?.location(in: sender).x ?? 0
        let currentStar = CGFloat(sender.tag) - (locationX > starWidth / 2 ? 0 : 0.5)
        
        let movedLocation = calculatePosotionFrom(star: currentStar)
        startCountLbl.bounceAnimation()
        changeCurrentRating(to: Float(currentStar))
        changeStarCount(to: Float(currentStar))
        animateRatingProgressView(to: movedLocation)
    }
    
    private func initial() {
        setUpGestureSetup()
        
        stackView.subviews.enumerated().forEach { aView in
            if let button = aView.element as? UIButton {
                button.addTarget(self, action: #selector(handleTapRating(_:forEvent:)), for: .touchUpInside)
            }
        }
        
        let initialPosition = calculatePosotionFrom(star: CGFloat(currentRating))
        animateRatingProgressView(to: initialPosition, isAnimate: false)
        
        changeStarCount(to: currentRating)
    }
    
    private func incrementRatings(newRating: Float) {
        changeStarCount(to: newRating)
        
        let locationX = calculatePosotionFrom(star: CGFloat(newRating))
        animateRatingProgressView(to: locationX)
    }
    
    private func setUpGestureSetup() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    private func changeCurrentRating(to rating: Float) {
        guard currentRating != rating else { return }
        
        currentRating = rating
        
        delegate?.handleRatingChanged(rating: currentRating * 2)
    }
    
    private func calculatePosotionFrom(star: CGFloat) -> CGFloat {
        let spacingCount = ceil(star) - 1
        return (star * starWidth) + (spacingCount * stackViewSpacing)
    }
    
    private func changeStarCount(to starCount: Float) {
        let prefix = "\(Int(starCount * 2))"
        let postfix = "/10"
        let count = "\(prefix)\(postfix)"
        
        if startCountLbl.text?.isEmpty == false && startCountLbl.text != count {
            UISelectionFeedbackGenerator().selectionChanged()
        }
        
        let attrubutesStr = NSMutableAttributedString(string: count)
        let range = NSRange(location: prefix.count, length: postfix.count)
        
        attrubutesStr.addAttributes([
            NSAttributedString.Key.font: UIFont(name: UIFont.FontStyle.regular.rawValue, size: 13)!,
            NSAttributedString.Key.foregroundColor: UIColor.C75
        ], range: range)
        
        startCountLbl.attributedText = attrubutesStr
    }
    
    private func animateRatingProgressView(to point: CGFloat, isAnimate: Bool = true) {
        let maxPoint = stackView.frame.width
        let translationX = max(0, min(maxPoint, point))
        
        UIView.easeSpringAnimation(isAnimate: isAnimate) {
            self.ratingProgressView.transform = .init(translationX: translationX, y: 0)
        }
    }
    
    private func animateStarCountLbl(isLarge: Bool) {
        UIView.easeSpringAnimation {
            self.startCountLbl.transform = isLarge ? .init(scaleX: 1.1, y: 1.1) : .identity
        }
    }
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var ratingProgressView: UIView!
    @IBOutlet weak var startCountLbl: UILabel!
    @IBOutlet weak var increaseActionBtn: MovieTVButton!
    @IBOutlet weak var reduceActionBtn: MovieTVButton!
    
    static let ratingVCSize: CGSize = .init(width: 272, height: 71)
    
    var currentRating: Float = 0.0
    weak var delegate: RatingViewControllerDelegate?
    
    private let starWidth: CGFloat = 24
    private let stackViewSpacing: CGFloat = 16
}
