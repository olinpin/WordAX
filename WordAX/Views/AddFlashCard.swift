//
//  addFlashCard.swift
//  WordAX
//
//  Created by Oliver Hnát on 07.04.2024.
//

import SwiftUI

struct AddFlashCard: View {
    @State var text: String = ""
    @State var description: String = ""
    @Binding var isShowing: Bool
    @Environment(\.managedObjectContext) var moc
    @FocusState private var focus: Bool
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Flashcard details") ) {
                    TextField("Name", text: $text)
                        .focused($focus)
                    TextField("Description", text: $description, axis: .vertical)
                }
                .onAppear {
                    self.focus = true
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
        try? moc.save()

    }
}

#Preview {
    @State var isShowing = true
    return AddFlashCard(isShowing: $isShowing)
        .environment(\.managedObjectContext, DataController.preview.container.viewContext)
}
