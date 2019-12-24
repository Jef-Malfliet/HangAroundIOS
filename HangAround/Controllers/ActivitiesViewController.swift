//
//  ViewController.swift
//  HangAround
//
//  Created by Jef Malfliet on 09/12/2019.
//  Copyright © 2019 Jef Malfliet. All rights reserved.
//

import UIKit

class ActivitiesViewController: UIViewController, APIManagerDelegate {
    
    @IBOutlet var activitiesTable: UITableView!
    private var apiManager = APIManager()
    
    var person: Person = Auth0Manager.instance.person!
    private var activities: [Activity?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activitiesTable.delegate = self
        activitiesTable.dataSource = self
        apiManager.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addActivity))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiManager.getActivities(personId: person.id)
    }
    
    @objc private func addActivity(){
        let alert = UIAlertController(title: "New Activity", message: "Name:", preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField { (textField) in
            textField.text = "name"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: {action in
            let textField = alert.textFields![0]
            if (textField.text != ""){
                let destination = self.storyboard?.instantiateViewController(withIdentifier: "ActivityDetailViewController") as! ActivityDetailViewController
                destination.activity = Activity(name: textField.text!)
                self.show(destination, sender: self)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func updatePerson(_ apiManager: APIManager, _ person: Person) {
        fatalError()
    }
    
    func updateFriends(_ apiManager: APIManager, _ friends: [Person?]) {
        fatalError()
    }
    
    func checkPersonExists(_ apiManager: APIManager, _ userExists: Bool) {
        fatalError()
    }
    
    func updateActivities(_ apiManager: APIManager, _ activities: [Activity?]) {
        self.activities = activities
        DispatchQueue.main.async {
            self.activitiesTable.reloadData()
        }
    }
    
    func updateActivity(_ apiManager: APIManager, _ activity: Activity) {
        fatalError()
    }
    
    func deleteActivity(_ apiManager: APIManager, _ activity: Activity) {
        activities.removeAll(where: {$0?.id == activity.id})
        DispatchQueue.main.async {
            self.activitiesTable.reloadData()
        }
    }
    
    func didFail(_ error: Error) {
        print(error.localizedDescription, error)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let activityDetailViewController = segue.destination as? ActivityDetailViewController,
            let index = activitiesTable.indexPathForSelectedRow?.row
            else {
                return
        }
        activityDetailViewController.activity = activities[index]!
    }
}

extension ActivitiesViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = activitiesTable.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath)
        if let safeActivity = activities[indexPath.row]{
            cell.textLabel?.text = safeActivity.name
            if(safeActivity.owner == self.person.id){
                cell.detailTextLabel?.text = "yours"
            } else {
                cell.detailTextLabel?.text = ""
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activity = activities[indexPath.row]
        let destination = ActivityDetailViewController()
        destination.activity = activity
        
        self.performSegue(withIdentifier: "ActivitiesToActivityDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(activities[indexPath.row]?.owner == person.id){
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            apiManager.deleteActivity(activityId: self.activities[indexPath.row]!.id)
        }
    }
}

