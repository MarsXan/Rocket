//
//  Rocket_iOS17App.swift
//  Rocket-iOS17
//
//  Created by mohsen mokhtari on 11/5/23.
//

import SwiftUI
import SwiftData

@main
struct RocketApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Expense.self,Category.self])
    }
}
