//
//  Firebase.swift
//  Pixart
//
//  Created by Hin Chan on 11/21/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import Foundation
import Firebase

struct ServerAPI {
    
    typealias ApiCompletion = ((_ response: [String: Any]?, _ error: String?) -> Void)
    
    static func login(email: String, password: String, _ completion: @escaping ApiCompletion) {
        Auth.auth().signIn(withEmail: email, password: password) { response, error in
            if error != nil {
                DispatchQueue.main.async { completion(nil, "Invalid Credentials") }
                return
            }
            
            LocalStorage.saveLogins(username: email, password: password)
            DispatchQueue.main.async { completion(nil, nil) }
        }
    }
}
