//
//  WordView.swift
//  WordAX
//
//  Created by Oliver Hnát on 24.02.2024.
//

import SwiftUI
import UIKit

struct FlashCardView: View {
    var flashcard: WordAX.FlashCard
    @Binding var showDescription: Bool
    @EnvironmentObject var model: WordAXModelView
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        let flashcardText = Text(flashcard.name)
            .font(.title)
            .bold()
        VStack {
            if flashcard.shown && flashcard.lastSeenOn != nil {
                Text("Last seen: " + model.getDateFormatter().string(from: flashcard.lastSeenOn!))
                    .font(.subheadline)
            }
            if showDescription {
                flashcardText
                    .textSelection(.enabled)
                Divider()
                    .background(colorScheme == .light ? Color.black : Color.white)
                    .padding(.horizontal)
                Text(flashcard.description)
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
    return FlashCardView(flashcard: WordAXModelView().getFlashCardsToDisplay()!, showDescription: $showDescription)
        .environmentObject(WordAXModelView())
}
