//
//  ViewController.swift
//  OnlineStoreCrash
//
//  Created by Gregor Dschung on 26.09.17.
//  Copyright © 2017 Gregor Dschung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    
    var retainedOnlineStore: SODataOnlineStore?

    @IBAction func ditTapOpenOnlineStoreWithoutCrash(_ sender: Any) {
        let conversationManager = HttpConversationManager()
        let url = URL(string: "http://services.odata.org/V2/Northwind/Northwind.svc/")
        retainedOnlineStore = SODataOnlineStore(url: url, httpConversationManager: conversationManager)
        retainedOnlineStore?.open { (store, error) in
            guard error == nil else {
                self.statusLabel.text = "An error occurred"
                return
            }
            
            self.statusLabel.text = "OnlineStore available"
        }
    }
    
    @IBAction func didTapOpenOnlineStoreWithCrash(_ sender: Any) {
        let conversationManager = HttpConversationManager()
        let url = URL(string: "http://services.odata.org/V2/Northwind/Northwind.svc/")
        let onlineStore: SODataOnlineStore = SODataOnlineStore(url: url, httpConversationManager: conversationManager)
        onlineStore.open { (store, error) in
            guard error == nil else {
                self.statusLabel.text = "An error occurred"
                return
            }
            
            self.statusLabel.text = "OnlineStore available"
        }
    }
}

