//
//  FirebaseBootcampApp.swift
//  FirebaseBootcamp
//
//  Created by Joseph Estrada on 3/13/23.
//

import SwiftUI
import Firebase

@main
struct FirebaseBootcampApp: App {
    
    init() {
        FirebaseApp.configure()
        print("Configured Firebase!")
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
