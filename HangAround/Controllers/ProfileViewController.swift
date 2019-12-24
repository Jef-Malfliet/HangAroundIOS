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
    @IBOutlet var buttonSave: UIButton!
    
    var person: Person = Auth0Manager.instance.person!
    
    var apiManager = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiManager.delegate = self
        textFieldName.addTarget(self, action: #selector(switchButton), for: .editingChanged)
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelEmail.text = person.email
        buttonSave.isEnabled = false
        updateName()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(self.buttonSave.isEnabled){
            let alert = UIAlertController(title: "Save", message: "Are you sure you want to dismiss your changes?", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.destructive, handler: { action in
                self.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: {action in
                self.save()
                self.buttonSave.isEnabled = false
                self.navigationController?.popViewController(animated: true)
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func saveNewName(_ sender: Any) {
        save()
    }
    
    private func save(){
        if(person.name != textFieldName.text!){
            person.name = textFieldName.text!
            apiManager.updatePerson(person: person)
            buttonSave.isEnabled = false
        }
    }
    
    @objc private func switchButton(){
        if(!buttonSave.isEnabled){
            buttonSave.isEnabled = true
        }
    }
    
    fileprivate func logoutAuth0() {
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
    
    @IBAction func logOut(_ sender: Any) {
        if(self.buttonSave.isEnabled){
            let alert = UIAlertController(title: "Save", message: "Are you sure you want to dismiss your changes?", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.destructive, handler: { action in
                self.logoutAuth0()
            }))
            alert.addAction(UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: {action in
                self.save()
                self.buttonSave.isEnabled = false
                self.logoutAuth0()
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            logoutAuth0()
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
