//
//  AnkiView.swift
//  WordAX
//
//  Created by Oliver Hnát on 23.02.2024.
//

import SwiftUI

struct AnkiView: View {
    @EnvironmentObject var model: WordAXModelView
    var word: WordAX.Word? {
        model.getWordToDisplay()
    }
    var body: some View {
        if word != nil {
            WordView(word: word!)
        } else {
            Text("There is no word to display, come back later")
        }
    }
}

#Preview {
    AnkiView()
        .environmentObject(WordAXModelView())
}
