//
//  FriendsViewController.swift
//  HangAround
//
//  Created by Jef Malfliet on 21/12/2019.
//  Copyright © 2019 Jef Malfliet. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, APIManagerDelegate {
    
    @IBOutlet var tableViewFriends: UITableView!
    @IBOutlet var buttonAdd: UIBarButtonItem!
    
    var person: Person = Auth0Manager.instance.person!
    private var friends: [Person?] = []
    
    var apiManager = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewFriends.delegate = self
        tableViewFriends.dataSource = self
        
        apiManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiManager.getFriends(personId: self.person.id)
    }
    
    func updatePerson(_ apiManager: APIManager, _ person: Person) {
        if (person.id == self.person.id){
            Auth0Manager.instance.person = person
            self.person = person
        }
        DispatchQueue.main.async {
            if let index = self.person.friends.firstIndex(where: {$0 == person.id}){
                if let cell = self.tableViewFriends.cellForRow(at: IndexPath(row: index, section: 0)){
                    (cell as! ActivityOwnerCell).labelOwner.text = person.name
                }
            }
        }
    }
    
    func updateFriends(_ apiManager: APIManager, _ friends: [Person?]) {
        self.friends = friends
        DispatchQueue.main.async {
            self.tableViewFriends.reloadData()
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
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewFriends.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath)
        if let safeFriend = friends[indexPath.row]{
            cell.textLabel?.text = safeFriend.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            friends.remove(at: indexPath.row)
            person.friends.remove(at: indexPath.row)
            apiManager.updatePerson(person: person)
        }
    }
}
