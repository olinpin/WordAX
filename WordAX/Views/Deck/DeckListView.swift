//
//  DeckListView.swift
//  WordAX
//
//  Created by Oliver Hnát on 01.05.2024.
//

import SwiftUI

struct DeckListView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "dateAdded", ascending: false)]) var decks: FetchedResults<Deck>
    @State var addDeck = false
    @Environment(\.managedObjectContext) var moc
    @State var editDeck: Bool = false
    @State var deckToEdit: Deck?
    var body: some View {
        NavigationStack {
            List {
                Button(action: {
                    self.addDeck = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add new deck")
                    }
                }
                ForEach(decks) { deck in
                    HStack {
                        Button {
                            deckToEdit = deck
                            editDeck = true
                        } label: {
                            Image(systemName: "pencil")
                                .contentShape(Rectangle())
                                .foregroundStyle(.blue)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        NavigationLink {
                            FlashCardListView(deck: deck)
                        } label: {
                            Text(deck.name ?? "Unknown deck name")
                        }
                        .contentShape(Rectangle())
                    }
                }
                .onDelete(perform: { offsets in
                    for index in offsets {
                        let deck = decks[index]
                        moc.delete(deck)
                    }
                    
                    do {
                        try moc.save()
                    } catch {
                        print("Something went wrong while deleting an object")
                    }
                })
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            .navigationTitle("All decks")
        }
        .sheet(isPresented: Binding(get: {editDeck}, set: {editDeck = $0})) {
            AddDeckView(isShowing: $editDeck, deck: deckToEdit)
        }
        .sheet(isPresented: $addDeck, content: {
            AddDeckView(isShowing: $addDeck)
        })
    }
    
}

#Preview {
    DeckListView()
        .environment(\.managedObjectContext, DataController.preview.container.viewContext)
}
