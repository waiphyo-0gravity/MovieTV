//
//  BackwardsCompactableHelper.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/13/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

class BackwardsCompactableHelper {
    static func handleAppStarting(with window: UIWindow?) {
        let barAppearance = UINavigationBar.appearance(whenContainedInInstancesOf: [MainNavViewcontroller.self])
        
        barAppearance.setBackgroundImage(UIImage(), for: .default)
        barAppearance.barTintColor = .white
        barAppearance.shadowImage = UIImage()
        
//        let rootVC = UserDefaultsHelper.shared.sessionID == nil ? LoginViewModel.createModule() : MainViewModel.createModule(isIncludeNavigation: true)
        
        let rootVC = UserDefaultsHelper.shared.userType == nil ? LoginViewModel.createModule() : MainContainerViewModel.createModule()
        
//        let rootVC = UIViewController.MainContainerViewController
        
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
    }

}
