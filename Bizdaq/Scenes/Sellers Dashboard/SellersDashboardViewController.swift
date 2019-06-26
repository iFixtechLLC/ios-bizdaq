//
//  SellersDashboardViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 21/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import JGProgressHUD

class SellersDashboardViewController: UIViewController, Modelled, Binds {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var optionsView: SellersOptionsView!
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var viewModel: SellersDashboardViewModel?
    
    private var businesses = [Business]()
    private var selectedBusiness: Business?
    
    private let progressHUD = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    func attach(to viewModel: SellersDashboardViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard let viewModel = viewModel else { preconditionFailure("viewModel not defined.") }
        registerCells()
        style()
        setupTableView()
        optionsView.delegate = self
        bind(to: viewModel)
    }

    override func viewWillAppear(_ animated: Bool) {
        progressHUD.parallaxMode = .alwaysOff

        progressHUD.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        progressHUD.show(in: view, animated: true)
        viewModel?.reloadData()
    }
    
    static func instance() -> UINavigationController? {
        guard let instance =  UIStoryboard(name: "SellersDashboard", bundle: Bundle.main).instantiateInitialViewController() as? UINavigationController else { return nil }
        return instance
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 334
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: "SellersStatsCell", bundle: Bundle.main), forCellReuseIdentifier: "sellersStatsCell")
        tableView.register(UINib(nibName: "AdvertCell", bundle: Bundle.main), forCellReuseIdentifier: "advertCell")
    }
    
    // MARK: - Styling
    private func style() {
        navigationItem.titleView = UIImageView(image: UIImage(named: Constants.bizdaqNavLogoImageName))
        navigationController?.navigationBar.style()
        setStatusBarStyle(.lightContent)
    }
    
    // MARK: - Binding
    func bind(to viewModel: SellersDashboardViewModel) {
        viewModel.businesses
            .drive(onNext: { [weak self] (businesses) in
                self?.businesses = businesses
                self?.tableView.reloadData()
                self?.progressHUD.dismiss(animated: true)
            })
            .disposed(by: bag)
    }
    
    // MARK: - Actions
    @IBAction func didPressMenuButton(_ sender: UIBarButtonItem) {
        Menu.shared.toggle(sender: view.window)
    }
}

// MARK: - Table View Data Source & Delegate
extension SellersDashboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "sellersStatsCell", for: indexPath) as? SellersStatsCell else { return UITableViewCell() }
            if let profile = viewModel?.sellerPublicProfile { cell.configure(with: profile) }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "advertCell", for: indexPath) as? AdvertCell else { return UITableViewCell() }
            cell.configure(for: businesses[indexPath.row - 1])
            cell.setEngagementButtonHandler { [weak self] in
                self?.selectedBusiness = self?.businesses[indexPath.row - 1]
                self?.navigate(to: .buyerEngagements, sender: self)
            }
            cell.setMarketingButtonHandler { [weak self] in
                self?.selectedBusiness = self?.businesses[indexPath.row - 1]
                self?.navigate(to: .marketing, sender: self)
            }
            cell.setEditButtonHandler { [weak self] in
                self?.selectedBusiness = self?.businesses[indexPath.row - 1]
                self?.navigate(to: .yourAdvert, sender: self)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            selectedBusiness = businesses[indexPath.row - 1]
            navigate(to: .yourAdvert, sender: self)
        }
    }
}

// MARK: - Sellers Options View Delegate
extension SellersDashboardViewController: SellersOptionsViewDelegate {
    
    func sellersOptionsView(_ view: SellersOptionsView, didPressButton atIndex: Int) {
        switch atIndex {
        case 0:
            navigate(to: .buildAdvert, sender: self)
        case 1:
            navigate(to: .messages, sender: self)
        case 2:
            Menu.shared.menuView?.setDocumentAsRoot()
//        case 3:
//            navigate(to: .offersList, sender: self)
        default:
            return
        }
    }
}

// MARK: - Navigation
extension SellersDashboardViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case buildAdvert
        case yourAdvert
        case buyerEngagements
        case offersList
        case marketing
        case messages
        case documents
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .buildAdvert:
            guard let destination = segue.destination as? BuildAdvertStepOneViewController else { return }
            destination.attach(to: ViewModelFactory.BuildAdvert.makeBuildAdvertViewModel(advertParameters: nil, isModal: true))
        case .yourAdvert:
            guard let destination = segue.destination as? YourAdvertViewController else { return }
            guard let business = selectedBusiness else { return }
            destination.attach(to: ViewModelFactory.YourAdvert.makeYourAdvertViewModel(business: business))
            selectedBusiness = nil
        case .buyerEngagements:
            guard let destination = segue.destination as? BuyerEngagementsViewController else { return }
            guard let business = selectedBusiness else { return }
            destination.attach(to: ViewModelFactory.SellersDashboard.makeBuyerEngagementsViewModel(business: business))
        case .offersList:
            guard segue.destination is OffersListTabViewController else { return }
            break
        case .documents:
            break
        case .messages:
            guard let destination = segue.destination as? ConversationListViewController else { preconditionFailure("Invalid destination") }
            destination.attach(to: ViewModelFactory.Messages.makeConversationListModel())
        case .marketing:
            guard let authToken = UserSession.shared.authToken else { preconditionFailure("AuthToken not available") }
            guard let destination = segue.destination as? MarketingViewController else { preconditionFailure("Invalid destination type") }
            guard let business = selectedBusiness else { preconditionFailure("Selected business not defined") }
            destination.attach(to: ViewModelFactory.Marketing.makeMarketingModel(authToken: authToken, business: business))
            selectedBusiness = nil
        }
    }
}

