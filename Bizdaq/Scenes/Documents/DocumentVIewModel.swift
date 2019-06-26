//
//  DocumentViewModel.swift
//  Bizdaq
//
//  Created by App Dev on 31/03/2019.
//  Copyright © 2019 Coherent Software. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MobileCoreServices

class DocumentViewModel {

    
    // MARK: - Properties
    //var documents = [Document]()
    // MARK: - Properties
    private let bag = DisposeBag()
    private let apiClient: APIProtocol
    // MARK: - Lifecycle
    private var type: String?
    var businessId: Int?
    private var businessName: String?
    private var businessField: ValidatedSelectionBox?
    private var myBusinesses = BehaviorRelay<[Business]>(value: [])
    var businessDriver: Driver<[Business]> { return myBusinesses.asDriver(onErrorJustReturn: []) }
    
    private var back: (() -> Void)?

    var myDocuments = BehaviorRelay<[Document]>(value: [])
    var documentsDriver: Driver<[Document]> { return myDocuments.asDriver(onErrorJustReturn: []) }
    func documents() -> [Document]?{
        return myDocuments.value
    }
    // MARK: - Lifecycle
    init(apiClient: APIClient) {
        self.apiClient = apiClient
        getMyBusinesses()
    }

    
    func setType(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.type = value }).disposed(by: bag)
    }
    func setBusiness(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in
            debugPrint(self!.myBusinesses.value.count)
            self!.myBusinesses.value.forEach({ (business) in
                if business.advertHeadline == value {
                    self!.businessId = business.id
                }
            })
            self?.businessName = value
        })
        .disposed(by: bag)
    }
    
    func getBusinessOptions(){
        guard businessField != nil else { return }
        var options = [String]()
        debugPrint(myBusinesses.value.count)
        if myBusinesses.value.count == 0 {
            businessField?.isUserInteractionEnabled = false
            let pum = PopupManager()
            pum.presentSimplePopup(then: {
                // go back
                self.back?()
            }, title: "No Businesses", description: "To add a document to business, please create one")
            
        }
        options = myBusinesses.value.map({ (business) in
            return business.advertHeadline ?? String.empty
        })
        businessField!.setOptions(options)
    }
    func uploadDocument(documentUrl: URL){
        guard type != nil else { return }
        guard businessId != nil else { return }
        
        let type_value = DynamicLexicon.getKeyByValue(array: DynamicLexicon.PreDefinedChoices.BusinessDocument.type, value: type)

        apiClient.createDocument(authToken: UserSession.shared.authToken!, businessId: businessId!, type: type_value, typeOther: type_value, year: "2018", doc: documentUrl)
            .subscribe(onSuccess: { (response) in
                if(response.success! && response.data != nil){
                    let doc = response.data?.businessDocument
                    self.addDocument(document: doc!)
                    let successdialog = PopupManager.init()
                    successdialog.presentSimplePopup(then: {},title: "Success", description: "Document uploaded" )
                }else {
                    debugPrint("error:Not success or nil data.")
                }
            }) { (error) in
                debugPrint("error:")
                debugPrint(error)
                guard error is HTTPClient.HTTPClientError else { return }
            }
            .disposed(by: bag)

    }

    func getDocuments(mybusinesses: [Business]){
        for business in mybusinesses {
            guard let businessId = business.id else { continue }
            apiClient.listBusinessDocuments(authToken: UserSession.shared.authToken!,
                                            businessId: businessId)
                .subscribe(onSuccess: { (response) in
                    for doc in (response.data?.businessDocuments)! {
                        self.addDocument(document: doc)
                    }
                }) { (error) in
                    debugPrint("error:")
                    debugPrint(error)
                    guard error is HTTPClient.HTTPClientError else { return }
                }
                .disposed(by: bag)
        }
        
    }
    public func setBusinessOptionsField(businessField: ValidatedSelectionBox){
        self.businessField = businessField
    }
    func getMyBusinesses(){
      
        
        guard let authToken = UserSession.shared.authToken else { return }
        guard let sellerPublicUserId = UserSession.shared.user?.publicUser.id else { return }
        apiClient.listBusinesses(authToken: authToken,
                        sellerPublicUserId: "\(sellerPublicUserId)",
                        sectorId: nil,
                        categoryId: nil,
                        locationId: nil,
                        tenure: nil,
                        askingPriceMin: nil,
                        askingPriceMax: nil,
                        page: nil,
                        perPage: nil,
                        showInactive: true)
            .subscribe(onSuccess: { [weak self] (response) in
                if var businessArray = self?.myBusinesses.value {
                    businessArray.append(contentsOf: response.data)
                    self?.myBusinesses.accept(businessArray)
                }
                self?.getBusinessOptions()
                self?.getDocuments(mybusinesses: self!.myBusinesses.value)
            }) { (error) in
                guard let error = error as? HTTPClient.HTTPClientError else { return }
                debugPrint(error)
            }
            .disposed(by: bag)
    }
    
    
    func addDocument(document: Document){
        if var docArray = documents() {
            docArray.append(document)
            self.myDocuments.accept(docArray)
        }
        //ocuments().append(document)
    }
    func removeDocument(index: Int){
        guard index < (documents()?.count)! && index >= 0 else { return }
        if var docArray = documents() {
            let document = docArray[index]
            
            guard let authToken = UserSession.shared.authToken else { return }
            guard let documentId = document.id else { return }
            
            
            apiClient.deleteDocument(authToken: authToken,
                                     businessDocumentId: documentId
                ).subscribe(onSuccess: { [weak self] (response) in
                    if( response.success ){
                        docArray.remove(at: index)
                        self?.myDocuments.accept(docArray)
                        let successdialog = PopupManager.init()
                        successdialog.presentSimplePopup(then: {},title: "Success", description: "Document deleted" )

                    }
                }) { (error) in
                    guard let error = error as? HTTPClient.HTTPClientError else { return }
                    debugPrint(error)
                }
                .disposed(by: bag)
        }
    }
    
    
    func setGoBack(backHandler: @escaping () -> Void){
        self.back = backHandler
        print("set back")
    }
}
