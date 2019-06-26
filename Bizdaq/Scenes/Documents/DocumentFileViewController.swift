//
//  DocumentFileViewController.swift
//  Bizdaq
//
//  Created by App Dev on 05/04/2019.
//  Copyright © 2019 Coherent Software. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class DocumentFileViewController: UIViewController {
    
    
    @IBOutlet weak var webView: WKWebView!
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
    private var document:Document?
    // MARK: - Lifecycle
    func attach(to document: Document) {
        self.document = document
    }
    
    override func viewDidLoad() {
        guard document != nil else { preconditionFailure("document not defined.") }

        super.viewDidLoad()
        let docUrl = Constants.Networking.imageServerURL + (document?.pathToFile)!
        //let urlS = "https://lists.w3.org/Archives/Public/uri/2004Nov/att-0015/App-Note-UseOfTheFileURLInJDF-031111.doc"
        debugPrint(docUrl)
        
        let url = URL(string: docUrl)
        var request = URLRequest(url: url!)
        if(Constants.Networking.development){
            request.setValue("Basic Yml6ZGFxOmxldG1laW5iaXpkYXE=", forHTTPHeaderField: "Authorization")
        }
        webView.load(request)
    }
}
