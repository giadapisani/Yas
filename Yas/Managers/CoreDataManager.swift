//
//  CoreDataManager.swift
//  Yas
//
//  Created by Giada Pisani on 29/12/22.
//

//this will help set up the core data stack
import Foundation
import CoreData

class CoreDataManager{
    
    let persistentContainer : NSPersistentContainer
    static let shared       : CoreDataManager = CoreDataManager()
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "SimpleToDoModel")
        persistentContainer.loadPersistentStores{
            description, error in
            if let error = error {
                fatalError("Unable to initialize Core Data \(error)")
            }
        }
    }
    
    
}
