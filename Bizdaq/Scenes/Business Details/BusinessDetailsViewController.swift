//
//  BusinessDetailsViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 14/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

final class BusinessDetailsViewController: UIViewController, Modelled, Binds {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var viewModel: BusinessDetailsViewModel?
    
    private enum CellIdentifier: String {
        case gallery = "GalleryCell"
        case information = "InformationCell"
        case access = "AccessCell"
        case overview = "OverviewCell"
        case propertyTable = "PropertyTableCell"
        case description = "DescriptionCell"
        case map = "MapCell"
    }
    
    private enum Section: Int {
        case gallery = 0
        case information
        case access
        case overview
        case propertyTable
        case description
        case map
    }
    
    private let numberOfSections = 1
    private let numberOfRows = 7
    
    private weak var accessCell: AccessCell?
    
    // MARK: - Lifecycle
    func attach(to viewModel: BusinessDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard let viewModel = viewModel else { preconditionFailure("viewModel not defined.") }
        setupTableView()
        bind(to: viewModel)
        style()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.updateBusinessEngagement()
        favouriteButton.image = viewModel?.isFavourited ?? false
            ? Theme.Icons.activeFavouriteIcon
            : Theme.Icons.inactiveFavouriteIcon
        tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        registerCells()
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: CellIdentifier.gallery.rawValue, bundle: Bundle.main),
                           forCellReuseIdentifier: CellIdentifier.gallery.rawValue)
        tableView.register(UINib(nibName: CellIdentifier.information.rawValue, bundle: Bundle.main),
                           forCellReuseIdentifier: CellIdentifier.information.rawValue)
        tableView.register(UINib(nibName: CellIdentifier.access.rawValue, bundle: Bundle.main),
                           forCellReuseIdentifier: CellIdentifier.access.rawValue)
        tableView.register(UINib(nibName: CellIdentifier.overview.rawValue, bundle: Bundle.main),
                           forCellReuseIdentifier: CellIdentifier.overview.rawValue)
        tableView.register(UINib(nibName: CellIdentifier.propertyTable.rawValue, bundle: Bundle.main),
                           forCellReuseIdentifier: CellIdentifier.propertyTable.rawValue)
        tableView.register(UINib(nibName: CellIdentifier.description.rawValue, bundle: Bundle.main),
                           forCellReuseIdentifier: CellIdentifier.description.rawValue)
        tableView.register(UINib(nibName: CellIdentifier.map.rawValue, bundle: Bundle.main),
                           forCellReuseIdentifier: CellIdentifier.map.rawValue)
    }
    
    // MARK: - Styling
    private func style() {
        navigationItem.titleView = UIImageView(image: UIImage(named: Constants.bizdaqNavLogoImageName))
    }
    
    // MARK: - Binding
    func bind(to viewModel: BusinessDetailsViewModel) {
        viewModel.businessEngagementDriver
            .drive(onNext: { [weak self] (businessEngagement) in
                self?.tableView.beginUpdates()
                self?.accessCell?.configure(with: businessEngagement)
                self?.tableView.endUpdates()
            })
            .disposed(by: bag)
    }
    
    // MARK: - Actions
    @IBAction func didPressBackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressFavouriteButton(_ sender: UIBarButtonItem) {
        guard let viewModel = viewModel else { return }
        guard let id = viewModel.business.id else { return }
        if UserSession.shared.authToken == nil {
            let pum = PopupManager()
            pum.presentConfirmPopup(then: {
                //CANCEL - DO NOTHING
            }, yeshandler: {
                //GOTOLOGIN
                Menu.shared.reintialise(sender: self.view.window)
                Menu.shared.menuView?.setLoginAsRoot()
            }, title: "You need to login to use this", description: "Login Now?")
            return
        }
        func setFavouriteImage(favourited: Bool) {
            favouriteButton.image = favourited
                ? Theme.Icons.activeFavouriteIcon
                : Theme.Icons.inactiveFavouriteIcon
        }
        
        if viewModel.isFavourited {
            viewModel.unfavourite(businessId: id) { (success) in
                setFavouriteImage(favourited: !success)
            }
        } else {
            viewModel.favourite(businessId: id) { (success) in
                setFavouriteImage(favourited: success)
            }
        }
    }
}

// MARK: - Table View Data Source & Delegate
extension BusinessDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case Section.gallery.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.gallery.rawValue,
                                                           for: indexPath) as? GalleryCell else {
                return UITableViewCell()
            }
            if let business = viewModel?.business { cell.configure(with: business) }
            return cell
        case Section.information.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.information.rawValue,
                                                           for: indexPath) as? InformationCell else {
                return UITableViewCell()
            }
            if let business = viewModel?.business { cell.configure(with: business) }
            return cell
        case Section.access.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.access.rawValue,
                                                           for: indexPath) as? AccessCell else {
                return UITableViewCell()
            }
            accessCell = cell
            accessCell?.delegate = self
            if let viewModel = viewModel { accessCell?.configure(with: viewModel.businessEngagement) }
            return cell
        case Section.overview.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.overview.rawValue,
                                                           for: indexPath) as? OverviewCell else {
                return UITableViewCell()
            }
            if let business = viewModel?.business { cell.configure(with: business) }
            return cell
        case Section.propertyTable.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.propertyTable.rawValue,
                                                           for: indexPath) as? PropertyTableCell else {
                return UITableViewCell()
            }
            if let business = viewModel?.business { cell.configure(with: business) }
            return cell
        case Section.description.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.description.rawValue,
                                                           for: indexPath) as? DescriptionCell else {
                return UITableViewCell()
            }
            if let business = viewModel?.business { cell.configure(with: business) }
            cell.setHandler { [weak self] in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
            }
            return cell
        case Section.map.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.map.rawValue,
                                                           for: indexPath) as? MapCell else {
                return UITableViewCell()
            }
            if let business = viewModel?.business { cell.configure(with: business) }
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - Access View Delegate
extension BusinessDetailsViewController: AccessViewDelegate {
    
    func accessViewDidPressMessageButton(state: AccessView.AccessState) {
        switch state {
        case .noAccess:
            if !UserSession.shared.isLoggedIn {
                let popup = RegisterPopup(loginButtonHandler: { [weak self] in
                    Popup.shared.dismiss()
                    self?.navigate(to: .login, sender: self)
                }) { [weak self] in
                    Popup.shared.dismiss()
                    self?.navigate(to: .register, sender: self)
                }
                Popup.shared.setPopupView(popup)
                Popup.shared.present()
            } else {
                viewModel?.createEngagement(completion: { [weak self] (success) in
                    if !success { self?.alert(title: Lexicon.universalError,
                                              message: Lexicon.BusinessDetail.Error.failedToCreateEngagement,
                                              handler: nil)
                    }
                })
            }
        case .requestedAccess:
            navigate(to: .messages, sender: self)
            // TODO: Implement message button on requested access view
            break
        case .grantedAccess:
            navigate(to: .messages, sender: self)
            // TODO: Implement message button on granted access view
            break
        }
    }
    
    func accessViewDidPressCancelButton() {
        //viewModel?.withdrawEngagement()
        //viewModel?.showRequestViewing()

        // TODO: Implement cancel button on requested access view
    }
    
    func accessViewDidPressCreateViewingButton() {
        viewModel?.showRequestViewing()
        //navigate(to: .createViewing, sender: self)
    }
    
    func accessViewDidPressKeyInfoButton() {
        viewModel?.showRequestDocument()
    }
    
    func accessViewDidPressMakeOfferButton() {
        viewModel?.showMakeOffer()

    }
}

// MARK: - Navigation
extension BusinessDetailsViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case login
        case register
        case createViewing
        case makeAnOffer
        case messages
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .login:
            guard let destination = segue.destination as? UINavigationController else { break }
            guard let loginViewController = destination.viewControllers.first as? LoginViewController else { break }
            loginViewController.attach(to: ViewModelFactory.Login.makeLoginModel(modallyPresented: true))
        case .register:
            guard let destination = segue.destination as? UINavigationController else { break }
            guard let registerViewController = destination.viewControllers.first as? ModalBuyerRegisterViewController else { break }
            registerViewController.attach(to: ViewModelFactory.Registration.makeModalRegistrationModel())
        case .createViewing:
            guard let business = viewModel?.business else { break }
            guard let engagement = viewModel?.businessEngagement else { break }
            guard let destination = segue.destination as? CreateViewingViewController else { break }
           destination.attach(to: ViewModelFactory.BusinessBrowse.makeCreateViewingModel(business: business, engagement: engagement))
        case .makeAnOffer:
            guard let engagementId = viewModel?.businessEngagement?.id else { break }
            guard let destination = segue.destination as? MakeOfferViewController else { break }
            destination.attach(to: ViewModelFactory.BusinessBrowse.makeMakeOfferModel(businessEngagementId: engagementId))
        case .messages:
            guard let engagementId = viewModel?.businessEngagement?.id else { break }
            guard let destination = segue.destination as? ConversationViewController else { preconditionFailure() }
            var myPic:UIImage? = nil

            if ((UserSession.shared.user?.publicUser.publicUserProfile?.photoPathToFile) != nil) {
                myPic = ImageCache.getUIImageFromPath(path: (UserSession.shared.user?.publicUser.publicUserProfile?.photoPathToFile)!, defaultUIImage: Theme.Icons.avatarPlaceholderIcon!)
            }
            destination.attach(to: ViewModelFactory.Messages.makeConversationModelFromEngagement(businessEngagementId: engagementId, contactImage: nil, userImage: myPic))
        }
    }
}

