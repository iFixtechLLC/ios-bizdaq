//
//  DocumentViewController.swift
//  Bizdaq
//
//  Created by App Dev on 31/03/2019.
//  Copyright © 2019 Coherent Software. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import MobileCoreServices
class DocumentViewController: UIViewController, Modelled, Binds  {
    
    @IBOutlet weak var uploadButton: UIButton!
    
    @IBOutlet weak var businessField: ValidatedSelectionBox!
    @IBOutlet weak var typeField: ValidatedSelectionBox!
    private let bag = DisposeBag()
    private var selectedDocument: Document?
    
    
    func bind(to viewModel: DocumentViewModel) {
        viewModel.setType(driver: typeField.valueDriver)
        viewModel.setBusiness(driver: businessField.valueDriver)
        
        viewModel.businessDriver
            .drive(onNext: { [weak self] (businesses) in
                
                self?.tableView.reloadData()
            })
            .disposed(by: bag)
        viewModel.documentsDriver
            .drive(onNext: { [weak self] (document) in
                
                self?.tableView.reloadData()
            })
            .disposed(by: bag)
    }
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Properties
    private var viewModel: DocumentViewModel?
    
    // MARK: - Lifecycle
    func attach(to viewModel: DocumentViewModel) {
        self.viewModel = viewModel
    }
    func buttonEnabled(isEnabled: Bool, button: UIButton){
        if isEnabled {
            button.backgroundColor = Theme.UIElements.activeButtonColor
        }else {
            button.backgroundColor = Theme.UIElements.inactiveButtonColor
        }
        button.isEnabled = isEnabled
    }
    
    override func viewDidLoad() {
        guard viewModel != nil else { preconditionFailure("viewModel not defined.") }
        bind(to: viewModel!)
        buttonEnabled(isEnabled: false, button: uploadButton)
        typeField.setPlaceholder("Type of Document")
        typeField.textField.addTarget(self, action: #selector(textFieldEditingDidChange), for: UIControlEvents.allEditingEvents)

        businessField.setPlaceholder("Business")
        businessField.textField.addTarget(self, action: #selector(textFieldEditingDidChange), for: UIControlEvents.allEditingEvents)
        if let typeOptions = DynamicLexicon.PreDefinedChoices.BusinessDocument.type {
            typeField.setOptions(typeOptions.values.sorted())
        }
        
        viewModel?.setGoBack(backHandler: {
            //back to page after login
            if UserSession.shared.user?.publicUser.publicUserSellerProfile != nil {
                Menu.shared.menuView?.setSellerDashboardAsRoot()
            }else if UserSession.shared.user?.publicUser.publicUserBuyerProfile != nil {
                Menu.shared.menuView?.setBuyersDashboardAsRoot()
            }else {
                Menu.shared.menuView?.setLoginAsRoot()
            }
        });
        
        viewModel?.setBusinessOptionsField(businessField: businessField)
        setupTable()
    
        navigationController?.navigationBar.style()
        setStatusBarStyle(.lightContent)


    }
    static func instance() -> UINavigationController? {
        guard let instance =  UIStoryboard(name: "Documents", bundle: Bundle.main).instantiateInitialViewController() as? UINavigationController else { return nil }
        return instance
    }
    var tempSector:Int?
    
    private func setupTable() {
        tableView.register(UINib(nibName: "DocumentCell", bundle: Bundle.main), forCellReuseIdentifier: "documentCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 72

        
    }
    @IBAction func uploadDocument(_ sender: Any) {
        self.attachDocument()
    }
    
    @IBAction func didPressMenuButton(_ sender: Any) {
        Menu.shared.toggle(sender: view.window)
    }
    

    @objc func textFieldEditingDidChange(_ sender: Any) {
        let typeOk = DynamicLexicon.PreDefinedChoices.BusinessDocument.type?.contains { $0.value == typeField.textField.text! }
        let ok = (typeOk ?? false) && (viewModel?.businessId != nil)
        buttonEnabled(isEnabled: ok, button: uploadButton)
    }

}

extension DocumentViewController: UIDocumentPickerDelegate, UINavigationControllerDelegate {
   
    private func attachDocument() {
        let types = [kUTTypePDF, kUTTypeText, kUTTypeRTF, kUTTypeSpreadsheet, kUTTypeJPEG]
        let importMenu = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)
        
        if #available(iOS 11.0, *) {
            importMenu.allowsMultipleSelection = true
        }
        
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        
        present(importMenu, animated: true)
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let myURL = url as URL
        print("import result : \(myURL)")
        viewModel?.uploadDocument(documentUrl: myURL)
        tableView.reloadData()
        guard viewModel?.documents() != nil && (viewModel?.documents()?.count)! > 0 else { return }
        let indexPath = IndexPath(row: (viewModel?.documents()!.count ?? 1)-1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    

}


// MARK: - Table View Delegate & Data Source
extension DocumentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint("COUNT"+String(viewModel!.myDocuments.value.count))
        return viewModel!.myDocuments.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath) as? DocumentCell {
            cell.titleLabel.text = viewModel!.myDocuments.value[indexPath.row].originalFilename
            let typekey = viewModel!.myDocuments.value[indexPath.row].type
            cell.typeLabel.text  = DynamicLexicon.PreDefinedChoices.BusinessDocument.type![typekey!]
            
            
            switch viewModel?.documents()?[indexPath.row].mimeType {
            case "application/pdf":
                cell.imageType.image = UIImage(named: "pdf_icon")
            case "text/plain":
                cell.imageType.image = UIImage(named: "txt_icon")
            case "application/vnd.openxmlformats-officedocument.wordprocessingml.document":
                cell.imageType.image = UIImage(named: "docx_icon")
            case "application/msword":
                cell.imageType.image = UIImage(named: "doc_icon")
            case "application/rtf":
                cell.imageType.image = UIImage(named: "txt_icon")
            case "application/vnd.ms-excel":
                cell.imageType.image = UIImage(named: "xls_icon")
            case "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet":
                cell.imageType.image = UIImage(named: "xlsx_icon")
            case "image/jpeg":
                cell.imageType.image = UIImage(named: "jpg_icon")
            case "image/png":
                cell.imageType.image = UIImage(named: "png_icon")
            default:
                cell.imageType.image = UIImage(named: "add_doc_icon")
            }
            //ImageCache.setImage(for: cell.imageType, pathToFile:"/uploads/public-user-profile-photo/public-user-profile-photo5ca5f4c2db7f6.png")
//            cell.sectorTextView.text = viewModel!.documents[indexPath.row].year
            cell.removeButton.tag = indexPath.row
            cell.removeButton.addTarget(self, action: #selector(removeDoc), for: .touchUpInside)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDocument = viewModel?.documents()?[indexPath.row]
        navigate(to: .showFile, sender: self)

    }
    
    @objc func removeDoc(sender: UIButton!) {
        self.viewModel?.removeDocument(index: sender.tag)
        self.tableView.reloadData()
    }
    
}

// MARK: - Navigation
extension DocumentViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case showFile
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .showFile:
            guard let destination  = segue.destination as? DocumentFileViewController else { return }
            if selectedDocument != nil {
                destination.attach(to: selectedDocument!)
            }else{
                return
            }
        }
    }
}
