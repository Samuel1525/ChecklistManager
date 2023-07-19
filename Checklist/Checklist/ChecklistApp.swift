//
//  ChecklistApp.swift
//  Checklist
//
//  Created by Samuel AYM on 19/07/23.
//

import SwiftUI

@main
struct ChecklistApp: App {
    @StateObject var toDoVM = ToDoModel()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(toDoVM)
        }
    }
}
