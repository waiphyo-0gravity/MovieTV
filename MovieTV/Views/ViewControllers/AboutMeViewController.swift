//
//  AboutMeViewController.swift
//  MovieTV
//
//  Created by ZeroGravity on 3/9/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit
import MessageUI

class AboutMeViewController: ViewController, MFMailComposeViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
    }
    
    @IBAction func clickedMailContactActionBtn(_ sender: Any) {
        if let gmailUrl = URL(string: "googlegmail://co?to=waiphyo.995@gmail.com"), UIApplication.shared.canOpenURL(gmailUrl) {
            UIApplication.shared.open(gmailUrl)
            return
        }
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["waiphyo.995@gmail.com"])

            present(mail, animated: true)
            return
        }
        
        if let mailUrl = URL(string: "mailto:waiphyo.995@gmail.com") {
            UIApplication.shared.open(mailUrl)
            return
        }
    }
    
    @IBAction func clickedPhoneContactActionBtn(_ sender: Any) {
        if let phoneUrl = URL(string: "tel://+959796516550") {
            UIApplication.shared.open(phoneUrl)
        }
    }
    
    @IBAction func clickedSocialMediaActionBtn(_ sender: UIButton) {
        let openUrl: URL?
        
        switch true {
        case sender == gitHubActionBtn:
            openUrl = URL(string: "https://github.com/waiphyo-0gravity")
        case sender == linkedInActionBtn:
            openUrl = URL(string: "https://www.linkedin.com/in/waiphyo995")
        case sender == twitterActionBtn:
            openUrl = URL(string: "https://twitter.com/waiphyo995")
        case sender == redditActionBtn:
            openUrl = URL(string: "https://www.reddit.com/user/superman-wp")
        default:
            openUrl = nil
        }
        
        guard let openURL = openUrl,
              UIApplication.shared.canOpenURL(openURL) else { return }
        
        UIApplication.shared.open(openURL)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    private func initial() {
        setUpCornerRadius()
        setUpMemojiImgView()
        setUpFirstMsgView()
        setUpContactInfoView()
        animateMsgViews(isShow: false, isAnimate: false)
    }
    
    private func setUpCornerRadius() {
        firstMsgView.cornerRadiusData = ([.topLeft, .topRight, .bottomRight], 20)
        secondMsgView.layer.cornerRadius = 20
        thirdMsgView.layer.cornerRadius = 20
        socialMediaMsgView.cornerRadiusData = ([.topLeft, .topRight, .bottomRight], 20)
        contactInfoMsgView.layer.cornerRadius = 20
        
        gitHubActionBtn.specificAnimateView = gitHubContainerView
        linkedInActionBtn.specificAnimateView = linkedInContainerView
        twitterActionBtn.specificAnimateView = twitterContainerView
        redditActionBtn.specificAnimateView = redditContainerView
        
        gitHubContainerView.layer.cornerRadius = 32 / 2
        linkedInContainerView.layer.cornerRadius = 32 / 2
        twitterContainerView.layer.cornerRadius = 32 / 2
        redditContainerView.layer.cornerRadius = 32 / 2
    }
    
    private func setUpMemojiImgView() {
        memojiImgView.animationImages = [UIImage(named: "memoji_smile")!, UIImage(named: "memoji_blink")!, UIImage(named: "memoji_peace")!]
        memojiImgView.animationDuration = 1.5
        memojiImgView.animationRepeatCount = 0
    }
    
    private func setUpFirstMsgView() {
        let prefixMsg = "Hi! This is me, "
        let postfixMsg = "Wai Phyo."
        
        let range = NSRange(location: prefixMsg.count, length: postfixMsg.count-1)
        
        let mutableAttrStr = NSMutableAttributedString(string: "\(prefixMsg)\(postfixMsg)")
        
        mutableAttrStr.addAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.Primary100
        ], range: range)
        
        firstMsgLbl.attributedText = mutableAttrStr
    }
    
    private func setUpContactInfoView() {
        if let mailTxt = mailContactInfoLbl.text {
            let mutableAttributedTxt = NSMutableAttributedString(string: mailTxt)
            mutableAttributedTxt.addAttributes([
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
            ], range: NSRange(location: 3, length: mailTxt.count-2))
            
            mailContactInfoLbl.attributedText = mutableAttributedTxt
        }
        
        if let phoneTxt = phoneContactInfoLbl.text {
            let mutableAttributedTxt = NSMutableAttributedString(string: phoneTxt)
            mutableAttributedTxt.addAttributes([
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
            ], range: NSRange(location: 3, length: phoneTxt.count-2))
            
            phoneContactInfoLbl.attributedText = mutableAttributedTxt
        }
        
        mailContactActonBtn.specificAnimateView = mailContactInfoLbl
        phoneContactActionBtn.specificAnimateView = phoneContactInfoLbl
    }
    
    func animateMsgViews(isShow: Bool, isAnimate: Bool = true) {
        let memojiTranslatingY = (view.frame.height / 2) - (scrollContentView.frame.height / 2)
            
        UIView.easeSpringAnimation(isAnimate: isAnimate) {
            self.memojiImgView.transform = isShow ? .identity : CGAffineTransform(translationX: -20, y: -memojiTranslatingY).concatenating(CGAffineTransform(scaleX: 0.8, y: 0.8))
        }
        
        guard !isAlreadyShowed else { return }
        
        let animationViews = [firstMsgView, secondMsgView, thirdMsgView, socialMediaMsgView, contactInfoMsgView]
        
        isAlreadyShowed = isShow && isAnimate
        
        animationViews.enumerated().forEach { aView in
            let delayTrigger = isShow ? aView.offset : animationViews.count - 1 - aView.offset
            
            let delay: Double
            
            switch true {
            case aView.element == socialMediaMsgView:
                delay = 1.75
            case aView.element == contactInfoMsgView:
                delay = 2
            default:
                delay = 0.25 * Double(delayTrigger)
            }
            
            UIView.easeSpringAnimation(isAnimate: isAnimate, delay: delay) {
                aView.element?.transform = isShow ? .identity : .init(translationX: 0, y: 24)
                aView.element?.alpha = isShow ? 1 : 0
            }
        }
    }
    
    private var isAlreadyShowed: Bool = false
    
    @IBOutlet weak var firstMsgView: FlexableCornerRadiusView!
    @IBOutlet weak var secondMsgView: FlexableCornerRadiusView!
    @IBOutlet weak var thirdMsgView: FlexableCornerRadiusView!
    @IBOutlet weak var socialMediaMsgView: FlexableCornerRadiusView!
    @IBOutlet weak var contactInfoMsgView: FlexableCornerRadiusView!
    @IBOutlet weak var firstMsgLbl: UILabel!
    @IBOutlet weak var memojiImgView: UIImageView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var mailContactInfoLbl: UILabel!
    @IBOutlet weak var phoneContactInfoLbl: UILabel!
    @IBOutlet weak var mailContactActonBtn: MovieTVButton!
    @IBOutlet weak var phoneContactActionBtn: MovieTVButton!
    @IBOutlet weak var gitHubContainerView: UIView!
    @IBOutlet weak var linkedInContainerView: UIView!
    @IBOutlet weak var twitterContainerView: UIView!
    @IBOutlet weak var redditContainerView: UIView!
    @IBOutlet weak var gitHubActionBtn: MovieTVButton!
    @IBOutlet weak var linkedInActionBtn: MovieTVButton!
    @IBOutlet weak var twitterActionBtn: MovieTVButton!
    @IBOutlet weak var redditActionBtn: MovieTVButton!
    
}
