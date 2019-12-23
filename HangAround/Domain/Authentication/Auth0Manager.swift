//
//  Auth0Manager.swift
//  HangAround
//
//  Created by Jef Malfliet on 22/12/2019.
//  Copyright © 2019 Jef Malfliet. All rights reserved.
//

import Foundation
import Auth0

class Auth0Manager{
    
    var personInfo: UserInfo?
    var credentials: Credentials?
    var person: Person?
    private let authentication = Auth0.authentication()
    let credentialsManager: CredentialsManager!
    
    static let instance = Auth0Manager()
    
    private init() {
        self.credentialsManager = CredentialsManager(authentication: Auth0.authentication())
        _ = self.authentication.logging(enabled: true)
    }
    
    func saveCredentials(credentials: Credentials) -> Bool{
        self.credentials = credentials
        return self.credentialsManager.store(credentials: credentials)
    }
    
    func getPersonInfo(_ callback: @escaping (Error?) -> ()) {
        guard let accessToken = self.credentials?.accessToken
            else { return callback(CredentialsManagerError.noCredentials) }
        self.authentication
            .userInfo(withAccessToken: accessToken)
            .start { result in
                switch(result) {
                case .success(let personInfo):
                    self.personInfo = personInfo
                    callback(nil)
                case .failure(let error):
                    callback(error)
                }
        }
    }
    
    func removeCredentials(_ callback: @escaping (Error?) -> Void) {
        self.personInfo = nil
        self.credentials = nil
        self.person = nil
        self.credentialsManager.revoke(callback)
    }
}
