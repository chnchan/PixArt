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

struct LocalStorage {
    
    static func saveLogins(username: String, password: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext) else { return }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            let user = try managedContext.fetch(fetchRequest)
            
            if let user = user.first {
                user.setValue(username, forKey: "username")
                user.setValue(password, forKey: "password")
            } else {
                let user = NSManagedObject(entity: entity, insertInto: managedContext)
                user.setValue(username, forKey: "username")
                user.setValue(password, forKey: "password")
            }
        }
        catch {
            print("Failed to fetch User:", error)
        }

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
    
    static func saveCanvasSize(size: Int = 8) { // 8x8 canvas size by default
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Settings", in: managedContext) else { return }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Settings")
        
        do {
            let settings = try managedContext.fetch(fetchRequest)
            
            if let settings = settings.first {
                settings.setValue(size, forKey: "canvas_size")
            } else {
                let settings = NSManagedObject(entity: entity, insertInto: managedContext)
                settings.setValue(size, forKey: "canvas_size")
            }
        }
        catch {
            print("Failed to fetch Settings:", error)
        }

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func fetchCanvasSize() -> Int {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return -1 }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Settings")
        
        do {
            let settings = try managedContext.fetch(fetchRequest)
            
            if let settings = settings.first {
                return settings.value(forKey: "canvas_size") as! Int
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return 8 // 8x8 canvas size by default
    }
}
