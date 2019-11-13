//
//  Storage.swift
//  Pixart
//
//  Created by Hin Chan on 11/12/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct Storage {
    
    static func saveLogins(username: String, password: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext) else { return }
        let user = NSManagedObject(entity: entity, insertInto: managedContext)
        
        user.setValue(username, forKey: "username")
        user.setValue(password, forKey: "password")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func fetchLogins() -> [NSManagedObject]? {
        var userInfo: [NSManagedObject] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            userInfo = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return userInfo
    }
}
