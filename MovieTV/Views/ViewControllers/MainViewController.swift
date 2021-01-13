//
//  MainViewController.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/13/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol MainViewProtocol: NSObjectProtocol {
    var viewModel: MainViewModelProtocol? { get set }
    
    static func createModule() -> UIViewController?
}

class MainViewController: UIViewController {
    var viewModel: MainViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoad()
    }
    
    static func createModule() -> UIViewController? {
        guard let viewController = UIViewController.MainViewController as? MainViewController else { return nil }
        
        var viewModel: MainViewModelProtocol = MainViewModel()
        viewController.viewModel = viewModel
        viewModel.view = viewController
        
        return viewController
    }
}

//  MARK: - VIEW_MODEL -> VIEW
extension MainViewController: MainViewProtocol {
    
}
