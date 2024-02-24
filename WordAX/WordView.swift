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
    var showDescription: Bool = true
    @EnvironmentObject var model: WordAXModelView
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Text(word.name)
                .font(.title)
                .bold()
            if word.shown && word.lastSeenOn != nil {
                Text(model.getDateFormatter().string(from: word.lastSeenOn!))
            }
            if showDescription {
                Divider()
                    .background(colorScheme == .light ? Color.black : Color.white)
                    .padding(.horizontal)
                Text(word.description)
                    .multilineTextAlignment(.center)
            }
        }
        .padding([.horizontal, .top])
    }
}

#Preview {
    WordView(word: WordAXModelView().getWordToDisplay()!)
        .environmentObject(WordAXModelView())
}
