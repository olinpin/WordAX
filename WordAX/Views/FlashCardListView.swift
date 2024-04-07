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
    var body: some View {
        GeometryReader { geometry in
            NavigationSplitView {
                Group {
                    if !model.flashcards.isEmpty {
                        List(model.flashcards) { word in
                            NavigationLink {
                                FlashCardView(flashcard: word, showDescription: $showDescription)
                            } label: {
                                FlashCardListRowView(flashcard: word)
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
                .navigationTitle("Word List")
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
                AddFlashCard(isShowing: $addFlashcard, addFlashCard: model.addFlashCard)
            })
        }
    }
}

#Preview {
    FlashCardListView()
        .environmentObject(WordAXModelView())
}
