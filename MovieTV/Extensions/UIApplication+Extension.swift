//
//  UIApplication+Extension.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/21/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

extension UIApplication {
    var firstKeyWindow: UIWindow? {
        return windows.first(where: { $0.isKeyWindow })
    }
}
