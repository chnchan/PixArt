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
    
    static func saveLogins(username: String, password: String, auto_signin: Bool = false) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext) else { return }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            let user = try managedContext.fetch(fetchRequest)
            
            if let user = user.first {
                user.setValue(username, forKey: "username")
                user.setValue(password, forKey: "password")
                user.setValue(auto_signin, forKey: "auto_signin")
            } else {
                let user = NSManagedObject(entity: entity, insertInto: managedContext)
                user.setValue(username, forKey: "username")
                user.setValue(password, forKey: "password")
                user.setValue(auto_signin, forKey: "auto_signin")
                user.setValue("", forKey: "alias")
                user.setValue(8, forKey: "canvas_size")
                user.setValue(0, forKey: "launch_option")
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
    
    static func saveProfileSettings(alias: String, size: Int, option: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            let user = try managedContext.fetch(fetchRequest)
            
            if let user = user.first {
                user.setValue(alias, forKey: "alias")
                user.setValue(size, forKey: "canvas_size")
                user.setValue(option, forKey: "launch_option")
            }
        }
        catch {
            print("Failed to fetch alias:", error)
        }

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func saveCanvasSize(size: Int = 8) { // 8x8 canvas size by default
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            let user = try managedContext.fetch(fetchRequest)
            
            if let user = user.first {
                user.setValue(size, forKey: "canvas_size")
            }
        }
        catch {
            print("Failed to fetch alias:", error)
        }

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func fetchAlias() -> String {
        var userInfo: [NSManagedObject] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return "" }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            userInfo = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return userInfo[0].value(forKey: "alias") as? String ?? ""
    }
    
    static func fetchEmail() -> String {
        var userInfo: [NSManagedObject] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return "" }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            userInfo = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return userInfo[0].value(forKey: "username") as! String
    }
    
    static func fetchLaunchOption() -> Int {
        var userInfo: [NSManagedObject] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return -1 }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            userInfo = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return userInfo[0].value(forKey: "launch_option") as? Int ?? 0
    }
    
    static func fetchCanvasSize() -> Int {
        var userInfo: [NSManagedObject] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return -1 }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            userInfo = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let size = userInfo[0].value(forKey: "canvas_size") as? Int ?? 8

        if size != 8 && size != 16 && size != 24 && size != 32 {
            return 8
        } else {
            return size
        }
    }
}
