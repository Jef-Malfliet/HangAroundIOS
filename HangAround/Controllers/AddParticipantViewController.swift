//
//  AddParticipantViewController.swift
//  HangAround
//
//  Created by Jef Malfliet on 20/12/2019.
//  Copyright © 2019 Jef Malfliet. All rights reserved.
//

import UIKit

class AddParticipantViewController: UIViewController {
    
    @IBOutlet var pickerFriends: UIPickerView!
    @IBOutlet var textFieldRole: UITextField!
    
    var delegate: AddParticipantViewControllerDelegate?
    
    var apiManager: APIManager?
    var friends: [Person?] = []
    var activity: Activity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        self.pickerFriends.delegate = self
        self.pickerFriends.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let index = pickerFriends.selectedRow(inComponent: 0)
        if(friends.count != 0){
            let personId = friends[index]!.id
            if let safeRole = textFieldRole.text{
                if (safeRole != "" && !activity!.participants.contains(where: {$0?.personId == personId})){
                    self.delegate?.addParticipant(PersonWithRole(personId: personId, role: safeRole))
                }
            }
        }
    }
    
}

extension AddParticipantViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return friends.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return friends[row]?.name
    }
}

protocol AddParticipantViewControllerDelegate {
    func addParticipant(_ personWithRole: PersonWithRole)
}
