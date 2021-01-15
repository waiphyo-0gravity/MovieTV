//
//  LoginViewModel.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/15/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import Foundation

protocol LoginViewModelProtocol {
    var view: LoginViewProtocol? { get set }
}

class LoginViewModel: LoginViewModelProtocol {
    weak var view: LoginViewProtocol?
}
