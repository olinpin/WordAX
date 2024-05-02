//
//  AddDeckView.swift
//  WordAX
//
//  Created by Oliver Hnát on 01.05.2024.
//

import SwiftUI

struct AddDeckView: View {
    @Binding var isShowing: Bool
    @Environment(\.managedObjectContext) var moc
    @State var name: String = ""
    var body: some View {
        NavigationStack {
            List {
                TextField("Name", text: $name)
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button(action: {
                        self.isShowing = false
                    }, label: {
                        Text("Cancel")
                            .foregroundStyle(.red)
                    })
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        let deck = Deck(context: moc)
                        deck.id = UUID()
                        deck.name = name
                        deck.dateAdded = Date()
                        do {
                            try moc.save()
                            self.isShowing = false
                        } catch {
                           print("Something went wrong while saving the deck")
                        }
                    }, label: {
                        Text("Create")
                            .bold()
                    })
                    .disabled(name.isEmpty)
                }
            }
            .navigationTitle("Add Deck")
        }
    }
}

#Preview {
    @State var isShowing = true
    return AddDeckView(isShowing: $isShowing)
        .environment(\.managedObjectContext, DataController.preview.container.viewContext)
}
