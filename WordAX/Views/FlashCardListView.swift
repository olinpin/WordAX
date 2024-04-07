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
        NavigationSplitView {
            List(model.flashcards) { word in
                NavigationLink {
                    FlashCardView(flashcard: word, showDescription: $showDescription)
                } label: {
                    FlashCardListRowView(flashcard: word)
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

#Preview {
    FlashCardListView()
        .environmentObject(WordAXModelView())
}
