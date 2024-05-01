//
//  DeckListView.swift
//  WordAX
//
//  Created by Oliver Hnát on 01.05.2024.
//

import SwiftUI

struct DeckListView: View {
    @FetchRequest(sortDescriptors: []) var decks: FetchedResults<Deck>
    @State var addDeck = false
    @Environment(\.managedObjectContext) var moc
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(decks) { deck in
                    Text(deck.name ?? "Unknown deck name")
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
                ToolbarItemGroup(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        self.addDeck = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("All decks")
        } detail: {
            Text("Select deck to get details about")
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
