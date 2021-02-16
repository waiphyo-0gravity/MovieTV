//
//  MovieDetailRatingView.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/15/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

class MovieDetailRatingView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view is UIButton ? view : nil
    }
}
