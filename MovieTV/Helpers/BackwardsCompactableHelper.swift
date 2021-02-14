//
//  BackwardsCompactableHelper.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/13/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

class BackwardsCompactableHelper {
    static func setDefaultAPIKeyIfNeeded() {
        guard UserDefaultsHelper.shared.apiKey == nil else { return }
        
        UserDefaultsHelper.shared.apiKey = "5d426f341099601fa75eea89f7598909"
    }
    
    static func handleAppStarting(with window: UIWindow?) {
        let barAppearance = UINavigationBar.appearance(whenContainedInInstancesOf: [MainNavViewcontroller.self])
        
        barAppearance.setBackgroundImage(UIImage(), for: .default)
        barAppearance.barTintColor = .white
        barAppearance.shadowImage = UIImage()
        
        let rootVC = UserDefaultsHelper.shared.sessionID == nil ? LoginViewModel.createModule() : MainViewModel.createModule(isIncludeNavigation: true)
        
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        
        window?.overrideUserInterfaceStyle = .light
    }

}
