//
//  ProfileViewController.swift
//  HangAround
//
//  Created by Jef Malfliet on 22/12/2019.
//  Copyright © 2019 Jef Malfliet. All rights reserved.
//

import UIKit
import Auth0

class ProfileViewController: UIViewController, APIManagerDelegate {
    
    @IBOutlet var textFieldName: UITextField!
    @IBOutlet var labelEmail: UILabel!
    
    var person: Person = Auth0Manager.instance.person!
    
    var apiManager = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiManager.delegate = self
        
        self.labelEmail.text = self.person.email
        updateName()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(person.name != textFieldName.text!){
            person.name = textFieldName.text!
            apiManager.updatePerson(person: person)
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        Auth0
            .webAuth()
            .clearSession(federated:false){
                switch $0{
                case true:
                    Auth0Manager.instance.removeCredentials({ (error) in
                        if (error == nil) {
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "unwindToLoginController", sender: self)
                            }
                        } else {
                            print(error!.localizedDescription)
                        }
                    })
                case false:
                    DispatchQueue.main.async {
                        print("logout unsuccessfull")
                    }
                }
        }
    }
    
    @objc private func changeName(){
        apiManager.updatePerson(person: person)
    }
    
    fileprivate func updateName() {
        DispatchQueue.main.async {
            self.textFieldName.text = self.person.name
        }
    }
    
    func updatePerson(_ apiManager: APIManager, _ person: Person) {
        Auth0Manager.instance.person = person
        self.person = person
        updateName()
    }
    
    func updateFriends(_ apiManager: APIManager, _ friends: [Person?]) {
        fatalError()
    }
    
    func checkPersonExists(_ apiManager: APIManager, _ userExists: Bool) {
        fatalError()
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
}
