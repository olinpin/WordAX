//
//  WordView.swift
//  WordAX
//
//  Created by Oliver Hnát on 24.02.2024.
//

import SwiftUI
import UIKit
import CoreData

struct FlashCardView: View {
    var flashcard: Flashcard
    @Binding var showDescription: Bool
    @Environment(\.colorScheme) var colorScheme
    @State var editFlashcard: Bool = false
    @State var showHint: Bool = false
    
    var body: some View {
        let flashcardText = Text(flashcard.name ?? "Unknown")
            .font(.title)
            .textSelection(.enabled)
            .bold()
        VStack {
            // TODO: Figure out if this and create/edit menu could be more similar?
            if flashcard.lastSeenOn != nil {
                Text("Last seen: " + Miscellaneous.dateFormatter.string(from: flashcard.lastSeenOn!))
                    .font(.subheadline)
            }
            if showDescription {
                // TODO: Add more information here
                if flashcard.shownCount != 0 {
                    Text("Already seen: \(flashcard.shownCount) \(flashcard.shownCount == 1 ? "time" : "times")")
                        .padding(.bottom)
                }
                flashcardText
                Divider()
                    .background(colorScheme == .light ? Color.black : Color.white)
                    .padding(.horizontal)
                Text(flashcard.desc ?? "No description added")
                    .multilineTextAlignment(.center)
            } else {
                flashcardText
            }
            if flashcard.hint != nil {
                if !showDescription {
                    Button {
                        showHint.toggle()
                    } label: {
                        Text(showHint ? "Hide Hint" : "Show Hint")
                            .padding()
                    }
                    if showHint {
                        Text((flashcard.hint != nil) ? "Hint: \(flashcard.hint ?? "")" : "")
                            .padding()
                            .font(.footnote)
                    }
                }
            }
        }
        .padding([.horizontal, .top])
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            self.showDescription = true
        }
        .sheet(isPresented: $editFlashcard) {
            AddFlashCardView(text: flashcard.name ?? "", description: flashcard.desc ?? "", isShowing: $editFlashcard, selectedDeck: flashcard.deck, flashcard: flashcard, edit: true)
        }
        .toolbar {
            Button {
                self.editFlashcard = true
            } label: {
                Text("Edit")
            }
        }
    }
}

#Preview {
    @State var showDescription = false
    let flashcard = try? DataController.preview.viewContext.fetch(Flashcard.fetchRequest()).first
    return FlashCardView(flashcard: flashcard!, showDescription: $showDescription)
        .environment(\.managedObjectContext, DataController.preview.container.viewContext)
}
