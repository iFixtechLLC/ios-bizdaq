//
//  MenuView.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 21/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class MenuView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var animatedView: UIView!
    @IBOutlet weak var closeImageView: UIImageView!
    @IBOutlet weak var sellersButtonBackground: UIView!
    @IBOutlet weak var sellersButtonLabel: UILabel!
    @IBOutlet weak var buyersButtonBackground: UIView!
    @IBOutlet weak var userAvatarBackground: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    // MARK: - Properties
    private let backgroundLayer = CAShapeLayer()
    private let animationDuration = 0.2
    private var isDisplayed = false
    private var statusBarStyle: UIStatusBarStyle?
    
    weak var appWindow: UIWindow?
    
    // MARK: - Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.insertSublayer(backgroundLayer, at: 0)
        setupBackgroundLayer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(backgroundLayer, at: 0)
        setupBackgroundLayer()
    }
    
    private func setupBackgroundLayer() {
        let screenFrame = UIScreen.main.bounds
        backgroundLayer.frame = CGRect(x: screenFrame.width * -3, y: 0, width: screenFrame.width * 3, height: screenFrame.height)
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: screenFrame.height),
                                CGPoint(x: screenFrame.width * 2, y: screenFrame.height),
                                CGPoint(x: screenFrame.width * 3, y: 0),
                                CGPoint(x: screenFrame.width, y: 0)], transform: CGAffineTransform(scaleX: 1, y: 1))
        backgroundLayer.path = path
        backgroundLayer.fillColor = UIColor.white.cgColor
        backgroundLayer.fillRule = kCAFillRuleEvenOdd
    }
    
    // MARK: - Styling
    private func style() {
        sellersButtonBackground.style(rounded: true)
        buyersButtonBackground.style(rounded: true)
        userAvatarBackground.layer.cornerRadius = userAvatarBackground.frame.width/2
        
        let loggedIn = UserSession.shared.isLoggedIn
        buyersButtonBackground.backgroundColor = loggedIn ? Theme.Menu.activeButtonColor : Theme.Menu.inactiveButtonColor
        sellersButtonBackground.backgroundColor = loggedIn ? Theme.Menu.activeButtonColor : Theme.Menu.inactiveButtonColor
        if loggedIn {
            styleSellersDashboardButton()
            let firstname = UserSession.shared.user?.publicUser.firstName ?? " "
            let lastname = UserSession.shared.user?.publicUser.lastName ?? " "
            
            usernameLabel?.text = firstname + " " + lastname
            
        }
    }
    
    private func styleSellersDashboardButton() {
        let sellerProfileExists = UserSession.shared.user?.publicUser.publicUserSellerProfile != nil
        sellersButtonBackground.backgroundColor = sellerProfileExists
            ? Theme.Menu.activeButtonColor
            : Theme.Menu.callToActionButtonColor
        sellersButtonLabel.text = sellerProfileExists
            ? Lexicon.Menu.SellerDashboard
            : Lexicon.Menu.createAdvert
    }
    
    // MARK: - Public Methods
    func show() {
        isHidden = false
        let screenFrame = UIScreen.main.bounds
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = [backgroundLayer.position.x, backgroundLayer.position.y]
        animation.toValue =  [backgroundLayer.position.x + screenFrame.width * 2, backgroundLayer.position.y]
        animation.duration = animationDuration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        backgroundLayer.add(animation, forKey: "position")
        backgroundLayer.position = CGPoint(x: backgroundLayer.position.x + screenFrame.width * 2, y: backgroundLayer.position.y)
        
        statusBarStyle = UIApplication.shared.statusBarStyle
        UIApplication.shared.statusBarStyle = .default
        style()
        animateFadeIn()
    }
    
    func hide() {
        let screenFrame = UIScreen.main.bounds
        CATransaction.begin()
        CATransaction.setCompletionBlock { self.isHidden = true }
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue =  [backgroundLayer.position.x, backgroundLayer.position.y]
        animation.toValue = [backgroundLayer.position.x - screenFrame.width * 2, backgroundLayer.position.y]
        animation.duration = animationDuration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        backgroundLayer.add(animation, forKey: "position")
        backgroundLayer.position = CGPoint(x: backgroundLayer.position.x - screenFrame.width * 2, y: backgroundLayer.position.y)
        CATransaction.commit()
        
        if statusBarStyle != nil { UIApplication.shared.statusBarStyle = statusBarStyle! }
        animateFadeOut()
    }
    
    // MARK: - Private Methods
    private func animateFadeIn() {
        self.animatedView.alpha = 0.0
        self.closeImageView.alpha = 0.0
        closeImageView.transform = CGAffineTransform(rotationAngle: (0 * .pi / 180))

        UIView.animate(withDuration: TimeInterval(0.4)) {
            self.animatedView.alpha = 1.0
            self.closeImageView.alpha = 1.0
            self.closeImageView.transform = CGAffineTransform(rotationAngle: (90 * .pi / 180))
        }
    }
    
    private func animateFadeOut() {
        UIView.animate(withDuration: TimeInterval(0.2)) {
            self.animatedView.alpha = 0.0
            self.closeImageView.alpha = 0.0
            self.closeImageView.transform = CGAffineTransform(rotationAngle: (0 * .pi / 180))
        }
    }
    
    func setSellerDashboardAsRoot() {
        guard let destination = SellersDashboardViewController.instance() else { return }
        guard let viewController = destination.viewControllers.first as? SellersDashboardViewController else { return }
        guard let sellerPublicProfile = UserSession.shared.user?.publicUser.publicUserSellerProfile else { return }
        let viewModel = ViewModelFactory.SellersDashboard.makeSellersDashboardViewModel(sellerPublicProfile: sellerPublicProfile)
        viewController.attach(to: viewModel)
        appWindow!.rootViewController = destination
    }
    
    func setBuyersDashboardAsRoot() {
        guard let destination = BuyersDashboardViewController.instance() else { return }
        guard let viewController = destination.viewControllers.first as? BuyersDashboardViewController else { return }
        guard let buyerPublicUserId = UserSession.shared.user?.publicUser.publicUserBuyerProfile?.id else { return }
        let viewModel = ViewModelFactory.BuyersDashboard.makeBuyersDashboardViewModel(buyerPublicUserId: buyerPublicUserId)
        viewController.attach(to: viewModel)
        appWindow!.rootViewController = destination
    }
    
    private func setBrowseBusinessesAsRoot() {
        guard let destination = BusinessBrowseTabViewController.instance() else { return }
        let navigationController = UINavigationController(rootViewController: destination)
        navigationController.navigationBar.style()
        appWindow!.rootViewController = navigationController
    }
    
    private func setBuildAdvertAsRoot() {
        guard let destination = BuildAdvertStepOneViewController.instance() else { return }
        guard let viewController = destination.viewControllers.first as? BuildAdvertStepOneViewController else { return }
        viewController.attach(to: ViewModelFactory.BuildAdvert.makeBuildAdvertViewModel(advertParameters: nil, isModal: false))
        appWindow!.rootViewController = destination
    }
    
    func setProfileAsRoot() {
        guard let destination = ProfileViewController.instance() else { return }
        guard let user = UserSession.shared.user else { return }
        guard let viewController = destination.viewControllers.first as? ProfileViewController else { return }
        viewController.attach(to: ViewModelFactory.Profile.makeProfileViewModel(user: user))
        appWindow!.rootViewController = destination
    }
    func setLoginAsRoot(){
        
        UserSession.shared.invalidate()
        guard let destination = LoginViewController.instance() else { return }
        guard let viewController = destination.viewControllers.first as? LoginViewController else { return }
        viewController.attach(to: ViewModelFactory.Login.makeLoginModel(modallyPresented: false))
        appWindow!.rootViewController = destination
    }
    
    
    private func setValueBusinessAsRoot(){
        guard let destination = ValuationViewController.instance() else { return }
        guard let user = UserSession.shared.user else { return }
        guard let viewController = destination.viewControllers.first as? ValuationViewController else { return }
        viewController.attach(to: ViewModelFactory.Valuation.makeValuationModel(authToken: user.token))
        appWindow!.rootViewController = destination
        
    }
    func setDocumentAsRoot(){
        guard let destination = DocumentViewController.instance() else { return }
        guard UserSession.shared.user != nil else { return }
        guard let viewController = destination.viewControllers.first as? DocumentViewController else { return }
        viewController.attach(to: ViewModelFactory.Documents.makeDocumentModel())
        appWindow!.rootViewController = destination
        
    }
    
    
    // MARK: - Actions
    @IBAction func didPressClose() {
        Menu.shared.toggle()
    }
    
    @IBAction func didPressSellersDashboardButton(_ sender: UIButton) {
        guard UserSession.shared.isLoggedIn else { return }
        if UserSession.shared.user?.publicUser.publicUserSellerProfile != nil {
            setSellerDashboardAsRoot()
        }else{
            setBuildAdvertAsRoot()
        }
        Menu.shared.toggle()
    }
    
    @IBAction func didPressBuyersDashboardButton(_ sender: UIButton) {
        guard UserSession.shared.isLoggedIn else { return }
        if UserSession.shared.user?.publicUser.publicUserBuyerProfile != nil {
            //setSellerDashboardAsRoot()
            setBuyersDashboardAsRoot()
        }
        Menu.shared.toggle()
    }

    
    @IBAction func didPressBrowseBusinessesButton(_ sender: UIButton) {
        setBrowseBusinessesAsRoot()
        Menu.shared.toggle()
    }
    
    @IBAction func didPressProfileButton(_ sender: UIButton) {
        if UserSession.shared.authToken == nil {
            let pum = PopupManager()
            pum.presentConfirmPopup(then: {
                //CANCEL - DO NOTHING
            }, yeshandler: {
                //GOTOLOGIN
                Menu.shared.menuView?.setLoginAsRoot()
            }, title: "You need to login to use this", description: "Login Now?")
        } else {
            setProfileAsRoot()
        }
        Menu.shared.toggle()
    }
    @IBAction func didPressSignOutButton(_ sender: UIButton) {
        setLoginAsRoot()
        Menu.shared.toggle()
    }
    @IBAction func didPressValueBusinessButton(_ sender: UIButton) {
        setValueBusinessAsRoot()
        Menu.shared.toggle()
    }
    @IBAction func didPressDocumentsButton(_ sender: UIButton) {
        if UserSession.shared.authToken == nil {
            let pum = PopupManager()
            pum.presentConfirmPopup(then: {
            }, yeshandler: {
                Menu.shared.menuView?.setLoginAsRoot()
            }, title: "You need to login to use this", description: "Login Now?")
        } else {
            setDocumentAsRoot()
        }
        Menu.shared.toggle()
        
    }
}
