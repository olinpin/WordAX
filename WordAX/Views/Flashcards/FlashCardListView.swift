//
//  AllWordsView.swift
//  WordAX
//
//  Created by Oliver Hnát on 25.02.2024.
//

import SwiftUI
import CoreData

struct FlashCardListView: View {
    @State var showDescription = true
    @State var addFlashcard: Bool = false
    @State var flashcards: [Flashcard] = []
    var deck: Deck?
    @Environment(\.managedObjectContext) var moc
    
    private struct AddButton: View {
        @Binding var addFlashcard: Bool
        var text: String
        var body: some View {
            Button(action: {
                self.addFlashcard = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .padding(.trailing)
                    Text(text)
                }
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                List {
                    AddButton(addFlashcard: $addFlashcard, text: "Add new Flashcard")
                        .frame(maxHeight: geometry.size.height / 10)
                    ForEach(flashcards) { flashcard in
                        NavigationLink {
                            FlashCardView(flashcard: flashcard, showDescription: $showDescription)
                        } label: {
                            FlashCardListRowView(flashcard: flashcard, refresh: refreshFlashcards)
                        }
                    }
                    .onDelete(perform: { offsets in
                        for index in offsets {
                            let flashcard = flashcards[index]
                            moc.delete(flashcard)
                            flashcards.remove(at: index)
                        }
                        
                        do {
                            try moc.save()
                        } catch {
                            print("Something went wrong while deleting an object")
                        }
                    })
                }
                .environment(\.defaultMinListRowHeight, geometry.size.height / 12)
                .onAppear {
                    refreshFlashcards()
                }
                .onChange(of: addFlashcard, { oldValue, newValue in
                    if oldValue {
                        refreshFlashcards()
                    }
                })
                .navigationBarTitle(deck?.name ?? "All Flashcards", displayMode: deck != nil ? .inline : .automatic)
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        EditButton()
                    }
                }
            }
            .sheet(isPresented: $addFlashcard, content: {
                AddFlashCardView(isShowing: $addFlashcard, selectedDeck: deck)
            })
        }
    }
    
    private func refreshFlashcards() {
        let request = NSFetchRequest<Flashcard>(entityName: "Flashcard")
        request.sortDescriptors = [NSSortDescriptor(key: "favorite", ascending: false), NSSortDescriptor(key: "dateAdded", ascending: false)]
        if deck != nil {
            request.predicate = NSPredicate(format: "deck == %@", deck!)
            //                        flashcards = deck?.flashcards?.allObjects as? [Flashcard] ?? []
        }
        do {
            flashcards = try moc.fetch(request)
        } catch {
            print("Something went wrong while fetching the flashcards")
            flashcards = []
        }
    }
    
}

#Preview {
    FlashCardListView()
        .environment(\.managedObjectContext, DataController.preview.container.viewContext)
}
