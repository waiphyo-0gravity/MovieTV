//
//  NibableHelperProtocol.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/23/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

//  MARK: - Nibable protocol.
protocol NibableProtocol {
    
}

extension NibableProtocol {
    static func createNib() -> UINib {
        let className = String(describing: Self.self)
        return UINib(nibName: className, bundle: nil)
    }
}

//  MARK: - Nibable Table cell protocol.
protocol NibableCellProtocol: NibableProtocol {
    
}

extension NibableCellProtocol {
    static var CELL_IDENTIFIER: String {
        return String(describing: Self.self)
    }
}
