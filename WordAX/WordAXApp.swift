//
//  WordAXApp.swift
//  WordAX
//
//  Created by Oliver Hnát on 19.02.2024.
//

import SwiftUI

@main
struct WordAXApp: App {
    @StateObject var model = WordAXModelView()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(model)
        }
    }
}
