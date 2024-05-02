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
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                Group {
                    if !flashcards.isEmpty {
                        List {
                            ForEach(flashcards) { flashcard in
                                NavigationLink {
                                    FlashCardView(flashcard: flashcard, showDescription: $showDescription)
                                } label: {
                                    FlashCardListRowView(flashcard: flashcard)
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
                    } else {
                        Group {
                            Text("You currently don't have any flashcards. To add flashcards, either click at the '+' button at the top or you can download them from the store (coming soon)")
                                .padding()
                                .background(.purple)
                                .clipShape(.buttonBorder)
                        }
                        .frame(maxHeight: .infinity)
                        .padding(.horizontal)
                    }
                }
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
                        Button(action: {
                            self.addFlashcard = true
                        }) {
                            Image(systemName: "plus")
                        }
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
            print(flashcards)
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
