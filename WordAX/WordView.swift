//
//  WordView.swift
//  WordAX
//
//  Created by Oliver Hnát on 24.02.2024.
//

import SwiftUI
import UIKit

struct WordView: View {
    var word: WordAX.Word
    @Binding var showDescription: Bool
    @EnvironmentObject var model: WordAXModelView
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        let wordText = Text(word.name)
            .font(.title)
            .bold()
        VStack {
            if word.shown && word.lastSeenOn != nil {
                Text("Last seen: " + model.getDateFormatter().string(from: word.lastSeenOn!))
                    .font(.subheadline)
            }
            if showDescription {
                wordText
                    .textSelection(.enabled)
                Divider()
                    .background(colorScheme == .light ? Color.black : Color.white)
                    .padding(.horizontal)
                Text(word.description)
                    .multilineTextAlignment(.center)
            } else {
                wordText
            }
        }
        .padding([.horizontal, .top])
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            self.showDescription = true
        }
    }
}

#Preview {
    @State var showDescription = false
    return WordView(word: WordAXModelView().getWordToDisplay()!, showDescription: $showDescription)
        .environmentObject(WordAXModelView())
}
