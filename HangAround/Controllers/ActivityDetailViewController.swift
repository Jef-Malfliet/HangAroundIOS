//
//  ActivityDetailViewController.swift
//  HangAround
//
//  Created by Jef Malfliet on 09/12/2019.
//  Copyright © 2019 Jef Malfliet. All rights reserved.
//

import UIKit

class ActivityDetailViewController: UIViewController, APIManagerDelegate, ParticipantsViewControllerDelegate {
    
    @IBOutlet var activityDetailTable: UITableView!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    private var apiManager = APIManager()
    
    var headerNames = ["Owner", "Place", "Description","Start date", "End date", "Participants"]
    var activity: Activity?
    var owner: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityDetailTable.dataSource = self
        activityDetailTable.delegate = self
        
        activityDetailTable.register(UINib(nibName: "ActivityOwnerCell", bundle: nil), forCellReuseIdentifier: "ReusableOwnerCell")
        activityDetailTable.register(UINib(nibName: "ActivityDetailCell", bundle: nil), forCellReuseIdentifier: "ReusablePropertyCell")
        activityDetailTable.register(UINib(nibName: "ActivityDateCell", bundle: nil), forCellReuseIdentifier: "ReusableDateCell")
        activityDetailTable.register(UINib(nibName: "ActivityDescriptionCell", bundle: nil), forCellReuseIdentifier: "ReusableDescriptionCell")
        activityDetailTable.register(UINib(nibName: "ParticipantsCell", bundle: nil), forCellReuseIdentifier: "ParticipantsCell")
        
        if let safeActivity = activity{
            self.title = safeActivity.name
            apiManager.getPerson(personId: safeActivity.owner)
        }
        
        saveButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiManager.delegate = self
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        if let safeActivity = activity{
            apiManager.updateActivity(activity: safeActivity)
        }
        switchButtonOff()
    }
    
    func updatePerson(_ apiMananger: APIManager, _ person: Person) {
        DispatchQueue.main.async {
            if let cell = self.activityDetailTable.cellForRow(at: IndexPath(row: 0, section: 0)){
                (cell as! ActivityOwnerCell).labelOwner.text = person.name
            }
        }
    }
    
    func updateFriends(_ apiMananger: APIManager, _ friends: [Person?]) {
        fatalError()
    }
    
    func updateActivities(_ apiMananger: APIManager, _ activities: [Activity?]) {
        fatalError()
    }
    
    func updateActivity(_ apiMananger: APIManager, _ activity: Activity) {
        self.activity = activity
    }
    
    func didFail(_ error: Error) {
        print(error.localizedDescription)
    }
    
    func activityHasChanged(_ activity: Activity?) {
        if let safeActivity = self.activity{
            if let safeUpdatedActivity = activity{
                if(safeActivity.participants.count != safeUpdatedActivity.participants.count || !safeActivity.participants.elementsEqual(safeUpdatedActivity.participants)){
                    self.activity = activity
                    switchButtonOn()
                }
            }
        }
    }
    
    private func switchButtonOn(){
        if(!saveButton.isEnabled){
            saveButton.isEnabled = true
        }
    }
    
    private func switchButtonOff(){
        if(saveButton.isEnabled){
            saveButton.isEnabled = false
        }
    }
}

extension ActivityDetailViewController: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate,UIPickerViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = activityDetailTable.dequeueReusableCell(withIdentifier: "ReusableOwnerCell", for: indexPath)
                as! ActivityOwnerCell
            apiManager.getPerson(personId: activity!.owner)
            return cell
        case 1:
            let cell = activityDetailTable.dequeueReusableCell(withIdentifier: "ReusablePropertyCell", for: indexPath)
                as! ActivityDetailCell
            cell.textviewPlace.text = activity?.place
            cell.textviewPlace.isScrollEnabled = false
            cell.textviewPlace.delegate = self
            return cell
        case 2:
            let cell = activityDetailTable.dequeueReusableCell(withIdentifier: "ReusableDescriptionCell", for: indexPath)
                as! ActivityDescriptionCell
            cell.textviewDescription.text = activity?.description
            cell.textviewDescription.isScrollEnabled = true
            cell.textviewDescription.delegate = self
            return cell
        case 3:
            let cell = activityDetailTable.dequeueReusableCell(withIdentifier: "ReusableDateCell", for: indexPath)
                as! ActivityDateCell
            if let date = activity?.startDate {
                cell.datepicker.date = date
            } else {
                cell.datepicker.date = Date()
            }
            cell.datepicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
            return cell
        case 4:
            let cell = activityDetailTable.dequeueReusableCell(withIdentifier: "ReusableDateCell", for: indexPath)
                as! ActivityDateCell
            if let date = activity?.endDate {
                cell.datepicker.date = date
            } else {
                cell.datepicker.date = Date()
            }
            cell.datepicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
            return cell
        case 5:
            return activityDetailTable.dequeueReusableCell(withIdentifier: "ParticipantsCell", for: indexPath)
        default:
            let cell = activityDetailTable.dequeueReusableCell(withIdentifier: "ReusableOwnerCell", for: indexPath)
                as! ActivityOwnerCell
            
            cell.labelOwner.text = ""
            return cell
        }
    }
    
    @objc private func dateChanged(){
        if let cellStartDate = self.activityDetailTable.cellForRow(at: IndexPath(row: 0, section: 3)){
            activity!.startDate = (cellStartDate as! ActivityDateCell).datepicker.date
        }
        if let cellEndDate = self.activityDetailTable.cellForRow(at: IndexPath(row: 0, section: 4)){
            activity!.endDate = (cellEndDate as! ActivityDateCell).datepicker.date
        }
        switchButtonOn()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 5){
            print("segue naar participants")
            print(indexPath.row)
            let destination = storyboard?.instantiateViewController(withIdentifier: "ParticipantsViewModel") as! ParticipantsViewController
            destination.activity = activity
            destination.apiManager = apiManager
            destination.delegate = self
            
            show(destination, sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerNames[section]
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let cellPlace = self.activityDetailTable.cellForRow(at: IndexPath(row: 0, section: 1)){
            activity!.place = (cellPlace as! ActivityDetailCell).textviewPlace.text
        }
        if let cellDescription = self.activityDetailTable.cellForRow(at: IndexPath(row: 0, section: 2)){
            activity!.description = (cellDescription as! ActivityDescriptionCell).textviewDescription.text
        }
        switchButtonOn()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4){
            return 200
        }
        return 44
    }
}
