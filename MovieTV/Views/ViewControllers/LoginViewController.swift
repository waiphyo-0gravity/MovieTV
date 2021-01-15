//
//  LoginViewController.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/15/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

protocol LoginViewProtocol: AnyObject {
    var viewModel: LoginViewModelProtocol? { get set }
}

class LoginViewController: UIViewController {

    var viewModel: LoginViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
    }
    
    private func initial() {
        view.touchAroundToHideKeyboard()
        loginBtn.layer.cornerRadius = 8
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func handleKeyboard(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        switch notification.name {
        case UIResponder.keyboardWillShowNotification:
            view.frame.size.height = UIScreen.main.bounds.height - keyboardSize.height
        case UIResponder.keyboardWillHideNotification:
            view.frame.size.height = UIScreen.main.bounds.height
        default: break
        }
        view.layoutIfNeeded()
    }
    
    static func createModule() -> UIViewController? {
        guard let viewController = UIViewController.LoginViewController as? LoginViewController else { return nil }
        
        var viewModel: LoginViewModelProtocol = LoginViewModel()
        
        viewController.viewModel = viewModel
        viewModel.view = viewController
        
        return viewController
    }
    
    @IBOutlet weak var helloLbl: UILabel!
    @IBOutlet weak var userNameTxtField: MovieTVTextField!
    @IBOutlet weak var passTxtField: MovieTVTextField!
    @IBOutlet weak var loginBtn: UIButton!
}

//  MARK: - VIEW_MODEL -> VIEW
extension LoginViewController: LoginViewProtocol {
    
}

extension LoginViewController {
    
}
