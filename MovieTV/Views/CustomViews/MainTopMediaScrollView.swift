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

class MainTopMediaScrollView: FlexableCornerRadiusScrollView {
    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    
    private func initial() {
        cornerRadiusData = ([UIRectCorner.bottomLeft], 38)
        delegate = self
        addStackView()
        addImgView()
    }
    
    private func addStackView() {
        addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func addImgView() {
        stackView.addArrangedSubview(movieCoverImgView)
        movieCoverImgView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        movieCoverImgView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    private func handleTrailerModelChanged() {
        guard var trailers = data?.results else { return }
        
        trailers = Array(trailers[0..<min(4, trailers.count)])
        
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
    }
    
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
    
    weak var customDelegate: MainTopMediaScrollViewDelegate?
    
    var data: MovieTrailerModel? {
        didSet {
            handleTrailerModelChanged()
        }
    }
    
    private var youtubePlayerViews: [YTPlayerView] = []
}

//  MARK: - Scroll view delegates.
extension MainTopMediaScrollView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customDelegate?.mainScrollViewDidScroll(scrollView: scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = round(scrollView.contentOffset.x / frame.width) - 1
        
        if currentPage >= 0 {
            youtubePlayerViews[Int(currentPage)].playVideo()
        }
        
        youtubePlayerViews.enumerated().forEach { player in
            if CGFloat(player.offset) != currentPage {
                player.element.stopVideo()
            }
        }
    }
}
