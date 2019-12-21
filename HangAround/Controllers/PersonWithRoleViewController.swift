//
//  PersonWithRoleViewController.swift
//  HangAround
//
//  Created by Jef Malfliet on 17/12/2019.
//  Copyright © 2019 Jef Malfliet. All rights reserved.
//

import UIKit

class PersonWithRoleViewController: UIViewController {
    
    @IBOutlet var textFieldRole: UITextField!
    
    var delegate: PersonWithRoleViewControllerDelegate?
    var personWithRole: PersonWithRole?
    var name: String?
    var activity: Activity?
    var apiManager: APIManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let safeName = name{
            self.title = safeName
        }
        if let safePerson = personWithRole{
            textFieldRole.text = safePerson.role
        }
        
        textFieldRole.addTarget(self, action: #selector(roleChanged), for: .editingChanged)
    }
    
    @objc private func roleChanged(){
        if let index = activity!.participants.firstIndex(where: {$0?.personId == personWithRole?.personId}){
            activity!.participants[index]?.role = textFieldRole.text!
            self.delegate?.updateActivityRole(activity, index)
        }
    }
}

protocol PersonWithRoleViewControllerDelegate {
    func updateActivityRole(_ activity: Activity?, _ index: Int)
}
