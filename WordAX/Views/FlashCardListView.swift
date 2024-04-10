//
//  AllWordsView.swift
//  WordAX
//
//  Created by Oliver Hnát on 25.02.2024.
//

import SwiftUI

struct FlashCardListView: View {
    @EnvironmentObject var model: WordAXModelView
    @State var showDescription = true
    @State var addFlashcard = false
//    @ObservedObject var flashcards = DataController.shared.getAllFlashcards()
    @FetchRequest(sortDescriptors: []) var flashcards: FetchedResults<Flashcard>
    var body: some View {
        GeometryReader { geometry in
            NavigationSplitView {
                Group {
                    if !flashcards.isEmpty {
                        List(flashcards) { flashcard in
                            NavigationLink {
                                FlashCardView(flashcard: flashcard, showDescription: $showDescription)
                            } label: {
                                FlashCardListRowView(flashcard: flashcard)
                            }
                        }
                    }
                    else {
                        Text("You currently don't have any flashcards. To add flashcards, either click at the '+' button at the top or you can download them from the store (coming soon)")
                            .padding()
                            .background(.purple)
                            .clipShape(.buttonBorder)
                            .frame(maxWidth: geometry.size.width - 30)
                    }
                }
                .navigationTitle("All Flashcards")
                .toolbar {
                    Button(action: {
                        self.addFlashcard = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            } detail: {
                Text("Select word to get details about")
            }
            .sheet(isPresented: $addFlashcard, content: {
                AddFlashCard(isShowing: $addFlashcard)
            })
        }
    }
}

//#Preview {
//    FlashCardListView()
//        .environmentObject(WordAXModelView())
//}