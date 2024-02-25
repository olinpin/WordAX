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
    @State var showDescription: Bool = false
    @EnvironmentObject var model: WordAXModelView
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        let wordText = Text(word.name)
            .font(.title)
            .bold()
        
        VStack {
            if word.shown && word.lastSeenOn != nil {
                Text(model.getDateFormatter().string(from: word.lastSeenOn!))
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
    WordView(word: WordAXModelView().getWordToDisplay()!)
        .environmentObject(WordAXModelView())
}
