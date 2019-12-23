//
//  AuthenticationViewController.swift
//  HangAround
//
//  Created by Jef Malfliet on 12/12/2019.
//  Copyright © 2019 Jef Malfliet. All rights reserved.
//

import UIKit
import Auth0

class AuthenticationViewController: UIViewController, APIManagerDelegate {
    
    @IBOutlet var buttonLoginRegister: UIButton!
    
    var apiManager = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiManager.delegate = self
    }
    
    @IBAction func unwindToLoginController(_ unwindSegue: UIStoryboardSegue) {
    }
    
    // MARK: - IBAction
    @IBAction func showLoginController(_ sender: Any) {
        guard let clientInfo = plistValues(bundle: Bundle.main) else { return }
        Auth0
            .webAuth()
            .scope("openid profile")
            .audience("https://" + clientInfo.domain + "/userinfo")
            .start {
                switch $0 {
                case .failure(let error):
                    print("Error: \(error)")
                case .success(let credentials):
                    if(Auth0Manager.instance.saveCredentials(credentials: credentials)){
                        Auth0Manager.instance.getPersonInfo { (error) in
                            DispatchQueue.main.async {
                                if( error != nil){
                                    print(error!.localizedDescription)
                                    return self.showLoginController(sender)
                                }
                                Auth0Manager.instance.getMetaData { (error) in
                                    if( error == nil){
                                        self.apiManager.checkPersonExists(personEmail: Auth0Manager.instance.personInfo!.name!)
                                    } else {
                                        print(error!.localizedDescription)
                                    }
                                }
                            }
                        }
                    } else {
                        print("Could not save credentials")
                    }
                }
        }
    }
    
    func updatePerson(_ apiManager: APIManager, _ person: Person) {
        Auth0Manager.instance.person = person
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "loginToTab", sender: self)
        }
    }
    
    func updateFriends(_ apiManager: APIManager, _ friends: [Person?]) {
        fatalError()
    }
    
    func checkPersonExists(_ apiManager: APIManager, _ userExists: Bool) {
        let email = Auth0Manager.instance.personInfo!.name!
        if userExists {
            let loginPersonDTO = LoginPersonDTO(email: email)
            self.apiManager.login(loginPersonDTO: loginPersonDTO)
        } else {
            let name = Auth0Manager.instance.metadata!["name"]! as! String
            let registerPersonDTO = RegisterPersonDTO(name: name, email: email, friends: [])
            self.apiManager.register(registerPersonDTO: registerPersonDTO)
        }
    }
    
    func updateActivities(_ apiManager: APIManager, _ activities: [Activity?]) {
        fatalError()
    }
    
    func updateActivity(_ apiManager: APIManager, _ activity: Activity) {
        fatalError()
    }
    
    func deleteActivity(_ apiManager: APIManager, _ activity: Activity) {
        fatalError()
    }
    
    func didFail(_ error: Error) {
        print(error.localizedDescription)
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

