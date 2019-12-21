//
//  SettingsViewController.swift
//  HangAround
//
//  Created by Jef Malfliet on 12/12/2019.
//  Copyright © 2019 Jef Malfliet. All rights reserved.
//

import UIKit
import Auth0

class SettingsViewController: UIViewController {
    
    private var isAuthenticated = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction private func logout(_ sender: Any){
        Auth0
            .webAuth()
            .clearSession(federated:false){
                switch $0{
                case true:
                    DispatchQueue.main.async {
                        self.isAuthenticated = false
                    }
                case false:
                    DispatchQueue.main.async {
                    }
                }
        }
    }
}
