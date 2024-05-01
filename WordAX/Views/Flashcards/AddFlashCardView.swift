//
//  addFlashCard.swift
//  WordAX
//
//  Created by Oliver Hnát on 07.04.2024.
//

import SwiftUI

struct AddFlashCardView: View {
    @State var text: String = ""
    @State var description: String = ""
    @Binding var isShowing: Bool
    @Environment(\.managedObjectContext) var moc
    @FocusState private var focus: Bool
    @FetchRequest(sortDescriptors: []) var decks: FetchedResults<Deck>
    @State var selectedDeck: Deck?
    @State var createDisabled: Bool = true
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Flashcard details") ) {
                    TextField("Name", text: $text)
                        .focused($focus)
                    TextField("Description", text: $description, axis: .vertical)
                    Picker("Deck", selection: $selectedDeck) {
                        ForEach(decks) { deck in
                            Text(deck.name ?? "Unknown deck name")
                                .tag(deck as Deck?)
                        }
                    }
                    .pickerStyle(.wheel)
                }
                .onAppear {
                    self.focus = true
                }
            }
            .onAppear {
                if selectedDeck == nil && !decks.isEmpty {
                    selectedDeck = decks[0]
                }
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
                        self.createFlashcard()
                        self.isShowing = false
                    }, label: {
                        Text("Create")
                            .bold()
                    })
                    .disabled(text.count == 0 || description.count == 0 || selectedDeck == nil)
                }
            }
            .navigationTitle("Add Flashcard")
        }
    }
    
    private func createFlashcard() {
        let flashcard = Flashcard(context: moc)
        flashcard.id = UUID()
        flashcard.name = self.text
        flashcard.desc = self.description
        flashcard.nextSpacedRepetitionMilestone = 0
        flashcard.lastSeenOn = nil
        flashcard.shownCount = 0
        flashcard.dateAdded = Date()
        flashcard.deck = selectedDeck
        try? moc.save()

    }
}

#Preview {
    @State var isShowing = true
    return AddFlashCardView(isShowing: $isShowing)
        .environment(\.managedObjectContext, DataController.preview.container.viewContext)
}
