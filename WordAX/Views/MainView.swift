//
//  ContentView.swift
//  WordAX
//
//  Created by Oliver Hnát on 19.02.2024.
//

import SwiftUI

struct MainView: View {
    @State var selectedTab = "Anki"
    init() {
        UITabBar.appearance().backgroundColor = UIColor.systemGray5
    }
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                Group {
                    AnkiView()
                        .tag("Anki")
                        .tabItem {
                            Image(systemName: "star")
                            Text("Anki")
                        }
                    FlashCardListView()
                        .tag("Flashcards")
                        .tabItem {
                            Image(systemName: "list.bullet")
                            Text("Flashcards")
                        }
                    DeckListView()
                        .tag("Decks")
                        .tabItem {
                            Image(systemName: "rectangle.stack")
                            Text("Decks")
                        }
                    SettingsView()
                        .tag("Settings")
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                }
            }
            
        }
        
    }
}

#Preview {
    MainView()
        .environment(\.managedObjectContext, DataController.preview.container.viewContext)
}
