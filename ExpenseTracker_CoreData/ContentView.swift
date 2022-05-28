//
//  ContentView.swift
//  ExpenseTracker_CoreData
//
//  Created by Saarthak Tuli on 20/05/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var databaseManager: DatabaseManager
    var body: some View {
        LaunchPage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
