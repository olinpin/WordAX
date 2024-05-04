//
//  DeckRowView.swift
//  WordAX
//
//  Created by Oliver Hnát on 04.05.2024.
//

import SwiftUI

struct DeckRowView: View {
    var deck: Deck
    var selected: Bool = false
    var body: some View {
        HStack {
            Text(deck.name ?? "Unknown")
            Spacer()
            if selected {
                Image(systemName: "checkmark")
            }
        }
    }
}

#Preview {
    let deck = try? DataController.preview.viewContext.fetch(Deck.fetchRequest()).first
    return DeckRowView(deck: deck!)
}
