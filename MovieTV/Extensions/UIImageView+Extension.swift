//
//  UIImageView+Extension.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/14/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImg(url: String?) {
        image = nil
        MovieTVImageDownloader.shared.download(url: url, imgView: self) {[weak self] img in
            self?.image = img
        }
    }
}
