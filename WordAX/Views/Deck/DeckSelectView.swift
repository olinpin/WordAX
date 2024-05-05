//
//  DeckSelectView.swift
//  WordAX
//
//  Created by Oliver Hnát on 04.05.2024.
//

import SwiftUI

struct DeckSelectView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var decks: FetchedResults<Deck>
    @Binding var selection: Set<Deck>
    @Binding var active: Bool
    var body: some View {
        NavigationStack {
            List(decks, id:\.self, selection: $selection) { deck in
                DeckRowView(deck: deck)
            }
            .environment(\.editMode, .constant(EditMode.active))
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        self.active = false
                    }, label: {
                        Text("Done")
                            .bold()
                    })
                }
            }
            .navigationTitle("Select Decks to display")
        }
    }
}

#Preview {
    @State var active = true
    @State var decksToDisplay = Set<Deck>()
    return DeckSelectView(selection: $decksToDisplay, active: $active)
        .environment(\.managedObjectContext, DataController.preview.container.viewContext)
}
