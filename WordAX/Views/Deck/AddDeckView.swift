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
    @State var deck: Deck?
    var edit: Bool
    
    init(isShowing: Binding<Bool>, deck: Deck? = nil) {
        self._isShowing = isShowing
        self._name = State(initialValue: deck?.name ?? "")
        self.deck = deck
        self.edit = deck != nil
    }
    
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
                        if let existingDeck = deck {
                            existingDeck.name = name
                        } else {
                            let currentDeck = Deck(context: moc)
                            currentDeck.id = UUID()
                            currentDeck.dateAdded = Date()
                            currentDeck.name = name
                        }
                        do {
                            try moc.save()
                            self.isShowing = false
                        } catch {
                            print("Something went wrong while saving the deck")
                        }
                    }, label: {
                        Text(edit ? "Edit": "Create")
                            .bold()
                    })
                    .disabled(name.isEmpty)
                }
            }
            .navigationTitle(edit ? "Edit Deck" : "Add Deck")
        }
    }
}

#Preview {
    @State var isShowing = true
    let deck = Deck(context: DataController.preview.container.viewContext)
    deck.id = UUID()
    return AddDeckView(isShowing: $isShowing, deck: deck)
        .environment(\.managedObjectContext, DataController.preview.container.viewContext)
}
