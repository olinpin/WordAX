//
//  AllWordsView.swift
//  WordAX
//
//  Created by Oliver Hnát on 25.02.2024.
//

import SwiftUI

struct WordListView: View {
    @EnvironmentObject var model: WordAXModelView
    @State var showDescription = true
    var body: some View {
        NavigationSplitView {
            List(model.words) { word in
                NavigationLink {
                    WordView(word: word, showDescription: $showDescription)
                } label: {
                    WordListRowView(word: word)
                }
            }
            .navigationTitle("Word List")
        } detail: {
            Text("Select word to get details about")
        }
    }
}

#Preview {
    WordListView()
        .environmentObject(WordAXModelView())
}
