//
//  WordAXApp.swift
//  WordAX
//
//  Created by Oliver Hnát on 19.02.2024.
//

import SwiftUI

@main
struct WordAXApp: App {
    @StateObject private var dataControler = DataController()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, dataControler.container.viewContext)
        }
    }
}
