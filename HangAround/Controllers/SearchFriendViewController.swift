//
//  SearchFriendViewController.swift
//  HangAround
//
//  Created by Jef Malfliet on 21/12/2019.
//  Copyright © 2019 Jef Malfliet. All rights reserved.
//

import UIKit

class SearchFriendViewController: UIViewController, APIManagerDelegate {
    
    @IBOutlet var textFieldSearch: UITextField!
    @IBOutlet var tableViewNewFriends: UITableView!
    
    private var apiManager = APIManager()
    
    private var addedFriend: Bool = false
    
    var person: Person = Auth0Manager.instance.person!
    private var persons: [Person?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewNewFriends.delegate = self
        tableViewNewFriends.dataSource = self
        
        apiManager.delegate = self
        
        textFieldSearch.addTarget(self, action: #selector(searchPerson), for: .editingChanged)
    }
    
    @objc private func searchPerson(){
        let name = textFieldSearch.text
        if (name != ""){
            apiManager.getPersonsWithNameLike(personName: name!)
        }
    }
    
    func updatePerson(_ apiManager: APIManager, _ person: Person) {
        Auth0Manager.instance.person = person
        self.person = person
        if(addedFriend){
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func updateFriends(_ apiManager: APIManager, _ friends: [Person?]) {
        self.persons = friends
        DispatchQueue.main.async {
            self.tableViewNewFriends.reloadData()
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

extension SearchFriendViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewNewFriends.dequeueReusableCell(withIdentifier: "NewFriendCell", for: indexPath)
        cell.textLabel?.text = persons[indexPath.row]?.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (!person.friends.contains(persons[indexPath.row]!.id)){
            person.friends.append(persons[indexPath.row]!.id)
            apiManager.updatePerson(person: person)
            addedFriend = true
        }
    }
}
