//
//  ProfileChooserViewModel.swift
//  MovieTV
//
//  Created by ZeroGravity on 3/25/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol ProfileChooserViewModelProtocol: AnyObject {
    var view: ProfileChooserViewProtocol? { get set }
    var data: [ProfileChooserModel] { get set }
    var avatarName: String? { get set }
    var currentSelectedAvatarIndex: Int? { get set }
    
    func mapData()
    func handleAvatarSelection(at index: Int) -> Bool
}

class ProfileChooserViewModel: ProfileChooserViewModelProtocol {
    weak var view: ProfileChooserViewProtocol?
    
    static func createModule(delegate: ProfileChooserViewDelegate? = nil, touchedFrame: CGRect = .zero, displayedName: String? = nil) -> UIViewController? {
        guard let viewController = UIViewController.ProfileChooserViewController as? ProfileChooserViewController else { return nil }
        
        let viewModel: ProfileChooserViewModelProtocol = ProfileChooserViewModel()
        
        viewController.touchedFrame = touchedFrame
        viewController.displayedName = displayedName
        viewController.delegate = delegate
        viewController.viewModel = viewModel
        viewModel.view = viewController
        
        return viewController
    }
    
    func mapData() {
        var allCases = ProfileData.allCases
        let currentAvatar = ProfileData(rawValue: avatarName ?? "")!
        allCases.removeAll(where: { $0 == currentAvatar })
        allCases = [currentAvatar] + allCases
        
        data = allCases.map({ ProfileChooserModel(profile: $0, transform: randomTransform()) })
    }
    
    func handleAvatarSelection(at index: Int) -> Bool {
        let selectedData = data[index]
        
        guard avatarName != selectedData.profile.rawValue else { return false }
        
        switch selectedData.profile {
        case .random:
            avatarName = ProfileData.makeRandom(except: ProfileData(rawValue: avatarName ?? ""))?.rawValue
        default:
            avatarName = selectedData.profile.rawValue
        }
        
        return true
    }
    
    private func randomTransform() -> CGAffineTransform? {
        return [
            CGAffineTransform(rotationAngle: .pi/36),
            CGAffineTransform(rotationAngle: .pi/60),
            CGAffineTransform(rotationAngle: -.pi/36),
            CGAffineTransform(rotationAngle: -.pi/60)
       ].randomElement()
    }
    
    enum ProfileData: String, CaseIterable {
        case rocket = "rocket_lottie", girlPower = "girl_power_lottie", ridingHorse = "riding_horse_lottie", coolPopCorn = "cool_pop_corn_lottie", meowWelcome = "meow_welcome_lottie", hipsterBeard = "hipster_beard_lottie", random = "random_lottie"
        
        var name: String {
            switch self {
            case .rocket:
                return "Rocket"
            case .girlPower:
                return "Girl with flowers"
            case .ridingHorse:
                return "Mexican fella"
            case .coolPopCorn:
                return "Mr. Popcorn"
            case .meowWelcome:
                return "Meow Meow"
            case .hipsterBeard:
                return "Hipster beard"
            case .random:
                return "Random?"
            }
        }
        
        static func makeRandom(except: ProfileData? = nil) -> ProfileData? {
            ProfileData.allCases.filter({ $0 != .random && $0 != except }).randomElement()
        }
    }
    
    var data: [ProfileChooserModel] = []
    var currentSelectedAvatarIndex: Int? = 0
    
    var avatarName: String? {
        get {
            UserDefaultsHelper.shared.avatarName
        }
        
        set {
            UserDefaultsHelper.shared.avatarName = newValue
        }
    }
}
