//
//  WidgetLearnApp.swift
//  WidgetLearn
//
//  Created by FunWidget on 2024/6/11.
//

import SwiftUI

@main
struct WidgetLearnApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
