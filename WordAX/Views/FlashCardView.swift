//
//  WordView.swift
//  WordAX
//
//  Created by Oliver Hnát on 24.02.2024.
//

import SwiftUI
import UIKit

struct FlashCardView: View {
    var flashcard: Flashcard
    @Binding var showDescription: Bool
    @EnvironmentObject var model: WordAXModelView
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        let flashcardText = Text(flashcard.name ?? "Unknown")
            .font(.title)
            .bold()
        VStack {
            if flashcard.lastSeenOn != nil {
                Text("Last seen: " + model.getDateFormatter().string(from: flashcard.lastSeenOn!))
                    .font(.subheadline)
            }
            if showDescription {
                flashcardText
                    .textSelection(.enabled)
                Divider()
                    .background(colorScheme == .light ? Color.black : Color.white)
                    .padding(.horizontal)
                Text(flashcard.desc ?? "No description added")
                    .multilineTextAlignment(.center)
            } else {
                flashcardText
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
    return FlashCardView(flashcard: DataController().getAllFlashcards()[0], showDescription: $showDescription)
        .environmentObject(WordAXModelView())
}
