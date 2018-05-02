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
    
    @IBAction func didTapButton(_ sender: Any) {
        log.error("Now it is going to crash!")
        let logUploaded = log.uploadLog()
        statusLabel.text = logUploaded ? "successful" : "failed"
    }
}

