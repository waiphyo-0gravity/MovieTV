//
//  AuthenticationViewModel.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/13/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import Foundation

protocol MainViewModelProtocol {
    var view: MainViewProtocol? { get set }
    
    func viewDidLoad()
}

class MainViewModel: MainViewModelProtocol {
    weak var view: MainViewProtocol?
    
    func viewDidLoad() {
        print(#function)
    }
}
