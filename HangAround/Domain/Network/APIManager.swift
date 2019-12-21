//
//  APIManager.swift
//  HangAround
//
//  Created by Jef Malfliet on 09/12/2019.
//  Copyright © 2019 Jef Malfliet. All rights reserved.
//

import Foundation

struct APIManager {
    
    //let BASEURL = "https://hangaround.herokuapp.com"
    
    let BASEURL = "https://7f90b59c.ngrok.io"
    var delegate: APIManagerDelegate?
    
    //MARK: - Activity
    
    func getActivities(personId: String){
        let url = "\(BASEURL)/getActivitiesContainingPerson?id=\(personId)"
        print(url)
        Get(urlString: url) { (data, response, error) in
            if error != nil {
                self.delegate?.didFail(error!)
                return
            }
            
            if let safeData = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
                do{
                    let activityContainer = try decoder.decode(ActivitiesNetworkContainer.self, from: safeData)
                    self.delegate?.updateActivities(self, activityContainer.activities)
                }catch{
                    self.delegate?.didFail(error)
                }
            }
        }
    }
    
    func getActivity(activityId: String){
        let url = "\(BASEURL)/getActivity?id=\(activityId)"
        
        Get(urlString: url) { (data, response, error) in
            if error != nil {
                self.delegate?.didFail(error!)
                return
            }
            
            if let safeData = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
                do{
                    let activity = try decoder.decode(Activity.self, from: safeData)
                    self.delegate?.updateActivity(self, activity)
                }catch{
                    self.delegate?.didFail(error)
                }
            }
        }
    }
    
    func makeActivity(activity: Activity){
        let url = "\(BASEURL)/makeActivity"
        print(url)
        let encoder = JSONEncoder()
        do{
            let data = try encoder.encode(activity.toDTO())
            Post(urlString: url, data: data) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFail(error!)
                    return
                }
                
                if let safeData = data {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
                    do{
                        let activity = try decoder.decode(Activity.self, from: safeData)
                        self.delegate?.updateActivity(self, activity)
                    }catch{
                        self.delegate?.didFail(error)
                    }
                }
            }
        }catch{
            print("couldn't encode activity while making")
        }
    }
    
    func updateActivity(activity: Activity){
        let url = "\(BASEURL)/updateActivity"
        print(url)
        let encoder = JSONEncoder()
        do{
            let data = try encoder.encode(activity.toDTO())
            Post(urlString: url, data: data) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFail(error!)
                    return
                }
                
                if let safeData = data {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
                    do{
                        let activityContainer = try decoder.decode(ActivitiesNetworkContainer.self, from: safeData)
                        self.delegate?.updateActivity(self, activityContainer.activities[0])
                    }catch{
                        self.delegate?.didFail(error)
                    }
                }
            }
        }catch{
            print("couldn't encode activity while updating")
        }
    }
    
    func deleteActivity(activityId: String){
        let url = "\(BASEURL)/deleteActivity?id=\(activityId)"
        print(url)
        Delete(urlString: url) { (data, response, error) in
            if(error != nil){
                self.delegate?.didFail(error!)
                return
            }
            if let safeData = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
                do{
                    let activityContainer = try decoder.decode(ActivitiesNetworkContainer.self, from: safeData)
                    self.delegate?.deleteActivity(self, activityContainer.activities[0])
                }catch{
                    self.delegate?.didFail(error)
                }
            }
        }
    }
    
    //MARK: - Person
    
    func getPerson(personId: String){
        let url = "\(BASEURL)/getPersonById?id=\(personId)"
        print(url)
        Get(urlString: url) { (data, response, error) in
            if(error != nil){
                self.delegate?.didFail(error!)
                return
            }
            
            if let safeData = data{
                let decoder = JSONDecoder()
                do{
                    let personContainer = try decoder.decode(PersonNetworkContainer.self, from: safeData)
                    self.delegate?.updatePerson(self, personContainer.persons[0])
                }catch{
                    self.delegate?.didFail(error)
                }
            }
        }
    }
    
    func getFriends(personId: String){
        let url = "\(BASEURL)/getFriendsOfPerson?id=\(personId)"
        
        Get(urlString: url) { (data, response, error) in
            if(error != nil){
                self.delegate?.didFail(error!)
                return
            }
            
            if let safeData = data{
                let decoder = JSONDecoder()
                do{
                    let personContainer = try decoder.decode(PersonNetworkContainer.self, from: safeData)
                    self.delegate?.updateFriends(self, personContainer.persons)
                }catch{
                    self.delegate?.didFail(error)
                }
            }
        }
    }
    
    func updatePerson(person: Person){
        let url = "\(BASEURL)/updatePerson"
        
        let encoder = JSONEncoder()
        do{
            let data = try encoder.encode(person)
            Post(urlString: url, data: data) { (data, response, error) in
                if(error != nil){
                    self.delegate?.didFail(error!)
                    return
                }
                
                if let safeData = data{
                    let decoder = JSONDecoder()
                    do{
                        let person = try decoder.decode(Person.self, from: safeData)
                        self.delegate?.updatePerson(self, person)
                    } catch {
                        self.delegate?.didFail(error)
                    }
                }
            }
        }catch{
            print("couldn't encode person while updating")
        }
    }
    
    //MARK: - Requests
    
    func Get(urlString: String, OnCompletionCallback: @escaping ( Data?, URLResponse?, Error? ) -> Void) {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: OnCompletionCallback)
            task.resume()
        }
    }
    
    func Post(urlString: String, data: Data, OnCompletionCallback: @escaping ( Data?, URLResponse?, Error? ) -> Void) {
        if let url = URL(string: urlString){
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = data
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: OnCompletionCallback)
            task.resume()
        }
    }
    
    func Delete(urlString: String, OnCompletionCallback: @escaping ( Data?, URLResponse?, Error? ) -> Void) {
        if let url = URL(string: urlString){
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: OnCompletionCallback)
            task.resume()
        }
    }
    
    func Put(urlString: String, data: Data, OnCompletionCallback: @escaping ( Data?, URLResponse?, Error? ) -> Void) {
        if let url = URL(string: urlString){
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "PUT"
            request.httpBody = data
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: OnCompletionCallback)
            task.resume()
        }
    }
}

protocol APIManagerDelegate {
    func updatePerson(_ apiManager: APIManager, _ person: Person)
    func updateFriends(_ apiManager: APIManager, _ friends: [Person?])
    func updateActivities(_ apiManager: APIManager, _ activities: [Activity?])
    func updateActivity(_ apiManager: APIManager, _ activity: Activity)
    func deleteActivity(_ apiManager: APIManager, _ activity: Activity)
    func didFail(_ error: Error)
}
