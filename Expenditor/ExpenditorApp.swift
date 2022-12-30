//
//  ExpenditorApp.swift
//  Expenditor
//
//  Created by Saarthak Tuli on 29/12/22.
//

import SwiftUI

@main
struct ExpenditorApp: App {
    @StateObject var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
