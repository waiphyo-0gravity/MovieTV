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
    var touchedFrame: CGRect { get set }
    var displayedName: String? { get set }
}

protocol ProfileChooserViewDelegate {
    func handleAvatarChanging()
    func animateAvatarView()
}

class ProfileChooserViewController: ViewController {
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
        if let row = viewModel?.currentSelectedAvatarIndex,
           let cell = collectionView.cellForItem(at: IndexPath(row: row, section: 0)) as? ProfileChooserCollectionViewCell {
            cell.layer.zPosition = 100
            cell.nameLbl.text = isShow ? data[row].profile.name : displayedName
            
            if !isShow && isAnimate && data[row].profile != .random {
                cell.profileLottieView.stop()
            }
        }
        
        UIView.easeSpringAnimation(isAnimate: isAnimate, animations: {
            self.blurView.alpha = isShow ? 1 : 0
            self.collectionView.visibleCells.forEach { aCell in
                guard let aCell = aCell as? ProfileChooserCollectionViewCell else { return }
                
                if isShow {
                    aCell.transform = .identity
                    
                    if let index = self.collectionView.indexPath(for: aCell)?.row {
                        aCell.profileContainerView.transform = self.data[index].transform ?? .identity
                    }
                }else {
                    aCell.profileContainerView.transform = .identity
                    let translateX = self.touchedFrame.origin.x - aCell.frame.origin.x - aCell.profileContainerView.frame.origin.x
                    let translateY = self.touchedFrame.origin.y - aCell.frame.origin.y - aCell.profileContainerView.frame.origin.y - self.collectionView.contentInset.top - (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)

                    aCell.transform = CGAffineTransform(translationX: translateX, y: translateY)
                    
                    if isAnimate {
                        aCell.profileContainerView.backgroundColor = .white
                        aCell.profileLottieView.backgroundColor = .ProfileBG
                    }
                }
            }
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
    var touchedFrame: CGRect = .zero
    var displayedName: String?
    
    var data = [ProfileChooserModel]() {
        didSet {
            collectionView.reloadData()
        }
    }
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
        
        viewModel?.currentSelectedAvatarIndex = indexPath.row
        
        if viewModel?.handleAvatarSelection(at: indexPath.row) == true {
            delegate?.handleAvatarChanging()
        }
        
        makeDismiss {
            self.delegate?.animateAvatarView()
        }
    }
}

//  MARK: VIEW_MODEL -> VIEW
extension ProfileChooserViewController: ProfileChooserViewProtocol {
    
}
