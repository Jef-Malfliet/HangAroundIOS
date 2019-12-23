//
//  ParticipantsViewController.swift
//  HangAround
//
//  Created by Jef Malfliet on 20/12/2019.
//  Copyright © 2019 Jef Malfliet. All rights reserved.
//

import UIKit

class ParticipantsViewController: UIViewController, APIManagerDelegate, PersonWithRoleViewControllerDelegate, AddParticipantViewControllerDelegate {
    
    @IBOutlet var tableviewParticipants: UITableView!
    
    var delegate: ParticipantsViewControllerDelegate?
    
    var activity: Activity?
    var apiManager: APIManager?
    var personNames: [Int:String] = [:]
    var person: Person = Auth0Manager.instance.person!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiManager?.delegate = self
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        self.title = "Participants"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(goToNewParticipant))
        
        tableviewParticipants.delegate = self
        tableviewParticipants.dataSource = self
        
        tableviewParticipants.register(UINib(nibName: "ActivityParticipantCell", bundle: nil), forCellReuseIdentifier: "ReusableParticipantCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.delegate?.activityHasChanged(activity)
    }
    
    @objc private func goToNewParticipant(){
        self.apiManager?.getFriends(personId: self.person.id)
    }
    
    func updatePerson(_ apiManager: APIManager, _ person: Person) {
        DispatchQueue.main.async {
            if let index = self.activity!.participants.firstIndex(where: {$0?.personId == person.id}){
                if let cell = self.tableviewParticipants.cellForRow(at: IndexPath(row: index, section: 0)){
                    (cell as! ActivityParticipantCell).labelName.text = person.name
                    self.personNames[index] = person.name
                }
            }
        }
    }
    
    func updateFriends(_ apiManager: APIManager, _ friends: [Person?]) {
        print("segue naar addParticipant")
        DispatchQueue.main.async {
            let destination = self.storyboard?.instantiateViewController(withIdentifier: "AddParticipantViewController") as! AddParticipantViewController
            destination.friends = friends
            destination.apiManager = apiManager
            destination.delegate = self
            destination.activity = self.activity
            self.show(destination, sender: self)
        }
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
    
    func updateActivityRole(_ activity: Activity?, _ index: Int) {
        if(activity!.participants[index]?.role != self.activity!.participants[index]?.role){
            self.activity = activity
            if let cell = self.tableviewParticipants.cellForRow(at: IndexPath(row: index, section: 0)){
                (cell as! ActivityParticipantCell).labelRole.text = self.activity?.participants[index]?.role
            }
        }
    }
    
    func addParticipant(_ personWithRole: PersonWithRole) {
        self.activity?.participants.append(personWithRole)
        tableviewParticipants.reloadData()
    }
    
    func deleteParticipant(_ personId: String) {
        self.activity?.participants.removeAll(where: {$0?.personId == personId})
        tableviewParticipants.reloadData()
    }
    
}

extension ParticipantsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activity!.participants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableviewParticipants.dequeueReusableCell(withIdentifier: "ReusableParticipantCell", for: indexPath)
            as! ActivityParticipantCell
        let participant = activity?.participants[indexPath.row]
        
        if let safeParticipant = participant{
            apiManager!.getPerson(personId: safeParticipant.personId)
        }
        cell.labelRole.text = participant?.role
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("segue naar participants")
        print(indexPath.row)
        let personWithRole = activity!.participants[indexPath.row]
        let destination = storyboard?.instantiateViewController(withIdentifier: "PersonWithRoleViewController") as! PersonWithRoleViewController
        destination.personWithRole = personWithRole
        destination.name = personNames[indexPath.row]
        destination.activity = activity
        destination.apiManager = apiManager
        destination.delegate = self
        
        show(destination, sender: self)
    }
}

protocol ParticipantsViewControllerDelegate {
    func activityHasChanged(_ activity: Activity?)
}
