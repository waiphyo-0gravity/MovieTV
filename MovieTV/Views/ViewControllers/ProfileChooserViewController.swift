//
//  ProfileChooserViewController.swift
//  MovieTV
//
//  Created by ZeroGravity on 3/24/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit
import Lottie

protocol ProfileChooserViewProtocol: AnyObject {
    var viewModel: ProfileChooserViewModelProtocol? { get set }
    var delegate: ProfileChooserViewDelegate? { get set }
}

protocol ProfileChooserViewDelegate {
    func handleAvatarChanging()
}

class ProfileChooserViewController: ViewController {

    var data = [ProfileChooserModel]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.mapData()
        initial()
        collectionView.layoutIfNeeded()
        collectionView.contentInset.top = max((collectionView.frame.height - collectionView.contentSize.height) / 2, 0)
        transition(isShow: false, isAnimate: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        transition(isShow: true, isAnimate: true)
    }
    
    override func transition(isShow: Bool, isAnimate: Bool, completion: ((Bool) -> Void)? = nil) {
        UIView.easeSpringAnimation(isAnimate: isAnimate, animations: {
            self.blurView.alpha = isShow ? 1 : 0
            self.collectionView.transform = isShow ? .identity : CGAffineTransform(translationX: 0, y: 64).concatenating(CGAffineTransform(scaleX: 0.009, y: 0.009))
        }, completion: completion)
    }
    
    @objc func handleClickedView() {
        makeDismiss()
    }
    
    private func initial() {
        setUpCollectionView()
        
        data = viewModel?.data ?? []
    }
    
    private func setUpCollectionView() {
        collectionView.register(ProfileChooserCollectionViewCell.createNib(), forCellWithReuseIdentifier: ProfileChooserCollectionViewCell.CELL_IDENTIFIER)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleClickedView))
        view.addGestureRecognizer(tap)
    }
    
    private func makeDismiss(completion: (()->Void)? = nil) {
        transition(isShow: false, isAnimate: true) {_ in
            self.dismiss(animated: false, completion: completion)
        }
    }
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: ProfileChooserViewModelProtocol?
    var delegate: ProfileChooserViewDelegate?
}

//  MARK: Collectionview delegates & datasources.
extension ProfileChooserViewController: UICollectionViewDataSource, UICollisionBehaviorDelegate, UICollectionViewDelegateFlowLayout, ProfileChooserCollectionViewCellDelegates {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileChooserCollectionViewCell.CELL_IDENTIFIER, for: indexPath) as? ProfileChooserCollectionViewCell else { return UICollectionViewCell() }
        
        cell.data = data[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == data.count - 1, data.count % 2 == 1 {
            return .init(width: UIScreen.main.bounds.width, height: 139)
        }
        
        let width = (UIScreen.main.bounds.width / 2) - ((collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0)
        return .init(width: width, height: 139)
    }
    
    func handleClickedProfile(for cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let isAvatarChanged = viewModel?.handleAvatarSelection(at: indexPath.row)
        
        makeDismiss {[weak self] in
            guard isAvatarChanged == true else { return }
            
            self?.delegate?.handleAvatarChanging()
        }
    }
}

//  MARK: VIEW_MODEL -> VIEW
extension ProfileChooserViewController: ProfileChooserViewProtocol {
    
}
