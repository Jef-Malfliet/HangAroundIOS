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
    
    private var activities: [Activity?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activitiesTable.delegate = self
        activitiesTable.dataSource = self
        apiManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiManager.getActivities(personId: "5dcff60a4d391c064b42089e")
    }
    
    func updatePerson(_ apiMananger: APIManager, _ peron: Person) {
        fatalError()
    }
    
    func updateFriends(_ apiMananger: APIManager, _ friends: [Person?]) {
        fatalError()
    }
    
    func updateActivities(_ apiMananger: APIManager, _ activities: [Activity?]) {
        self.activities = activities
        DispatchQueue.main.async {
            self.activitiesTable.reloadData()
        }
    }
    
    func updateActivity(_ apiMananger: APIManager, _ activity: Activity) {
        fatalError()
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
        activityDetailViewController.activity = activities[index]
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
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("segue naar detail")
        let activity = activities[indexPath.row]
        let destination = ActivityDetailViewController()
        destination.activity = activity
        
        self.performSegue(withIdentifier: "ActivitiesToActivityDetail", sender: self)
    }
}

