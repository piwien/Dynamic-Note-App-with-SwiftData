//
//  Dynamic_Note_App_with_SwiftDataApp.swift
//  Dynamic Note App with SwiftData
//
//  Created by Berkay Yaşar on 21.10.2023.
//

import SwiftUI

@main
struct Dynamic_Note_App_with_SwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: NoteData.self)
    }
}
