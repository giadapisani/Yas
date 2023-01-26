//
//  YasApp.swift
//  Yas
//
//  Created by Giada Pisani on 29/12/22.
//

import SwiftUI

@main
struct YasApp: App {
    
    let persistentContainer = CoreDataManager.shared.persistentContainer
    
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistentContainer.viewContext) //accedi al contenuto da ogni view
        }
    }
}
