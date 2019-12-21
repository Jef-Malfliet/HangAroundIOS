//
//  AuthenticationViewController.swift
//  HangAround
//
//  Created by Jef Malfliet on 12/12/2019.
//  Copyright © 2019 Jef Malfliet. All rights reserved.
//

import UIKit
import Auth0

class AuthenticationViewController: UIViewController {
    
    private var isAuthenticated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBAction
    @IBAction func showLoginController(_ sender: UIButton) {
        guard let clientInfo = plistValues(bundle: Bundle.main) else { return }
        
        if(!isAuthenticated){
            Auth0
                .webAuth()
                .scope("openid profile")
                .audience("https://" + clientInfo.domain + "/userinfo")
                .start {
                    switch $0 {
                    case .failure(let error):
                        print("Error: \(error)")
                    case .success(let credentials):
                        guard let accessToken = credentials.accessToken else { return }
                        
                        DispatchQueue.main.async {
                            self.showSuccessAlert("accessToken: \(accessToken)")
                            self.isAuthenticated = true
                            sender.setTitle("Log out", for: .normal)
                        }
                    }
            }
        }
        else{
           
        }
    }
    
    // MARK: - Private
    fileprivate func showSuccessAlert(_ message: String) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

func plistValues(bundle: Bundle) -> (clientId: String, domain: String)? {
    guard
        let path = bundle.path(forResource: "Auth0", ofType: "plist"),
        let values = NSDictionary(contentsOfFile: path) as? [String: Any]
        else {
            print("Missing Auth0.plist file with 'ClientId' and 'Domain' entries in main bundle!")
            return nil
    }
    
    guard
        let clientId = values["ClientId"] as? String,
        let domain = values["Domain"] as? String
        else {
            print("Auth0.plist file at \(path) is missing 'ClientId' and/or 'Domain' entries!")
            print("File currently has the following entries: \(values)")
            return nil
    }
    return (clientId: clientId, domain: domain)
}

