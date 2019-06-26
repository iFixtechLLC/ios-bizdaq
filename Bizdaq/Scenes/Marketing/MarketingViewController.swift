//
//  MarketingViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 08/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding

class MarketingViewController: UIViewController, Modelled, Binds {
    
    // MARK: - Outlets
    @IBOutlet weak var advertsEmptyStateView: UIView!
    @IBOutlet weak var promosEmptyStateView: UIView!
    @IBOutlet weak var advertsTableView: UITableView!
    @IBOutlet weak var promosTableView: UITableView!
    @IBOutlet weak var addressLine1Field: ValidatedTextField!
    @IBOutlet weak var addressLine2Field: ValidatedTextField!
    @IBOutlet weak var addressLine3Field: ValidatedTextField!
    @IBOutlet weak var townCityField: ValidatedTextField!
    @IBOutlet weak var postcodeField: ValidatedTextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    // MARK: - Properties
    private var viewModel: MarketingViewModel?
    private let advertLinksDataSource = AdvertLinksTableDataSource(cellIdentifier: AdvertLinkCell.id)
    private let promoEmailsDataSource = PromosTableDataSource(cellIdentifier: PromoCell.id)
    
    // MARK: - Lifecycle
    func attach(to viewModel: MarketingViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard let viewModel = viewModel else { preconditionFailure("viewModel not defined.") }
        setup(with: viewModel.business)
        bind(to: viewModel)
        style()
        addTouchGestureRecognizer(to: contentScrollView)
        KeyboardAvoiding.avoidingView = contentScrollView
        
        registerCells()
        setupAdvertsTable()
        setupPromoTable()
    }
    
    private func registerCells() {
        advertsTableView.register(UINib(nibName: "AdvertLinkCell", bundle: nil), forCellReuseIdentifier: AdvertLinkCell.id)
        promosTableView.register(UINib(nibName: "PromoCell", bundle: nil), forCellReuseIdentifier: PromoCell.id)
    }
    
    private func setupAdvertsTable() {
        if let zooplaLink = viewModel?.business.zooplaAdvertLink {
            advertLinksDataSource.links.append(zooplaLink)
        }
        if let daltonsLink = viewModel?.business.daltonsAdvertLink {
            advertLinksDataSource.links.append(daltonsLink)
        }
        if !advertLinksDataSource.links.isEmpty {
            advertsEmptyStateView.isHidden = true
            advertsTableView.layoutIfNeeded()
            advertsTableView.dataSource = advertLinksDataSource
            advertsTableView.delegate = advertLinksDataSource
            advertsTableView.reloadData()
            advertsTableView.translatesAutoresizingMaskIntoConstraints = false
            advertsTableView.heightAnchor.constraint(equalToConstant: CGFloat(advertLinksDataSource.links.count) * AdvertLinkCell.cellHeight).isActive = true
            advertsTableView.layoutIfNeeded()
        }
    }
    
    private func setupPromoTable() {
        promosTableView.layoutIfNeeded()
        promosTableView.dataSource = promoEmailsDataSource
        promosTableView.delegate = promoEmailsDataSource
        viewModel?.getBusinessPromoEmails { [weak self] (response) in
            guard let `self` = self else { return }
            guard let response = response else { return }
            switch response {
            case .success(let promoEmails):
                if !promoEmails.isEmpty {
                    self.promosEmptyStateView.isHidden = true
                    self.promoEmailsDataSource.promoEmails = promoEmails
                    self.promosTableView.reloadData()
                    self.promosTableView.translatesAutoresizingMaskIntoConstraints = false
                    self.promosTableView.heightAnchor.constraint(equalToConstant: CGFloat(self.promoEmailsDataSource.promoEmails.count + 1) * PromoCell.cellHeight).isActive = true
                    self.promosTableView.layoutIfNeeded()
                }
            case .error(_):
                break
            }
        }
    }
    
    // MARK: - Styling
    private func style() {
        updateButton.style(rounded: true)
        advertsEmptyStateView.style(rounded: true, radius: advertsEmptyStateView.frame.height/2)
        promosEmptyStateView.style(rounded: true, radius: promosEmptyStateView.frame.height/2)
    }
    
    // MARK: - Binding
    func bind(to viewModel: MarketingViewModel) {
        viewModel.setAddressLine1(addressLine1Field.valueDriver)
        viewModel.setAddressLine2(addressLine2Field.valueDriver)
        viewModel.setAddressLine3(addressLine3Field.valueDriver)
        viewModel.setTownCity(townCityField.valueDriver)
        viewModel.setPostcode(postcodeField.valueDriver)
    }
    
    // MARK: - Private Methods
    private func setup(with model: Business) {
        addressLine1Field.setText(viewModel?.business.address?.line1)
        addressLine2Field.setText(viewModel?.business.address?.line2)
        addressLine3Field.setText(viewModel?.business.address?.line3)
        townCityField.setText(viewModel?.business.address?.townCity)
        postcodeField.setText(viewModel?.business.address?.postcode)
    }
    
    private func addTouchGestureRecognizer(to scrollView: UIScrollView) {
        let touchRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.canCancelContentTouches = false
        scrollView.addGestureRecognizer(touchRecognizer)
    }
    
    private func endEditingAllFields() {
        addressLine1Field.endEditing(true)
        addressLine2Field.endEditing(true)
        addressLine3Field.endEditing(true)
        townCityField.endEditing(true)
        postcodeField.endEditing(true)
    }
    
    // MARK: - Actions
    @IBAction func didPressBackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressUpdateButton(_ sender: UIButton) {
        viewModel?.saveChanges(completion: { [weak self] (success) in
            guard let `self` = self else { return }
            func navigateBack() {
                self.navigationController?.popViewController(animated: true)
            }
            !success ? self.alert(title: Lexicon.universalError, message: "Unable to update, please try again later", handler: { (_) in
                navigateBack()
            }) : navigateBack()
        })
    }
    
    @objc func hideKeyboard() {
        endEditingAllFields()
    }
}
