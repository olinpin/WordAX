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
        } detail: {
            Text("Select word to get details about")
        }
    }
}

#Preview {
    FlashCardListView()
        .environmentObject(WordAXModelView())
}
