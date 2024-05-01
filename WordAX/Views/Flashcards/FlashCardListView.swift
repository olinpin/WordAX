//
//  AllWordsView.swift
//  WordAX
//
//  Created by Oliver Hnát on 25.02.2024.
//

import SwiftUI

struct FlashCardListView: View {
    @State var showDescription = true
    @State var addFlashcard = false
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "favorite", ascending: false), NSSortDescriptor(key: "dateAdded", ascending: false)]) var flashcards: FetchedResults<Flashcard>
    @Environment(\.managedObjectContext) var moc
    var body: some View {
        GeometryReader { geometry in
            NavigationSplitView {
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
                                }
                                
                                do {
                                    try moc.save()
                                } catch {
                                    print("Something went wrong while deleting an object")
                                }
                            })
                        }
                    } else {
                        Text("You currently don't have any flashcards. To add flashcards, either click at the '+' button at the top or you can download them from the store (coming soon)")
                            .padding()
                            .background(.purple)
                            .clipShape(.buttonBorder)
                            .frame(maxWidth: geometry.size.width - 30)
                    }
                }
                .navigationTitle("All Flashcards")
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        EditButton()
                    }
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button(action: {
                            self.addFlashcard = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            } detail: {
                Text("Select flashcard to get details about")
            }
            .sheet(isPresented: $addFlashcard, content: {
                AddFlashCardView(isShowing: $addFlashcard)
            })
        }
    }
}

#Preview {
    FlashCardListView()
        .environment(\.managedObjectContext, DataController.preview.container.viewContext)
}
