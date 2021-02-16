//
//  MovieTVImageDownloader.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/14/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

typealias MovieTVImageDownloaderResponse = (UIImage?) -> Void

class MovieTVImageDownloader {
    static let shared = MovieTVImageDownloader()
    
    private let imgCaches = NSCache<NSURL, UIImage>()
    
    private var imageViewMapper = [UIImageView: NSURL]()
    
    init() {
        imgCaches.countLimit = 20
        imgCaches.totalCostLimit = 50 * 1024 * 1024
    }
    
    func download(url: String?, imgView: UIImageView?, response: MovieTVImageDownloaderResponse? = nil) {
        
        guard let urlStr = url,
              let url = NSURL(string: urlStr) else {
            response?(nil)
            return
        }
        
        if let imgCache = imgCaches.object(forKey: url) {
            DispatchQueue.main.async {
                response?(imgCache)
            }
            return
        }
        
        if let imgView = imgView {
            imageViewMapper[imgView] = url
        }
        
        URLSession.shared.dataTask(with: url as URL) {[weak self, imgView] (data, resp, error) in
            defer {
                if let imgMapIndex = self?.imageViewMapper.firstIndex(where: { $0.key == imgView }) {
                    self?.imageViewMapper.remove(at: imgMapIndex)
                }
            }
            
            guard let data = data,
                  let img = UIImage(data: data) else {
                DispatchQueue.main.async {
                    response?(nil)
                }
                return
            }
            
            self?.imgCaches.setObject(img, forKey: url)
            
            if let imgView = imgView, self?.imageViewMapper[imgView] != url {
                return
            }
            
            DispatchQueue.main.async {
                response?(img)
            }
        }.resume()
    }
}
