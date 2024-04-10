//
//  WordListRowView.swift
//  WordAX
//
//  Created by Oliver Hnát on 25.02.2024.
//

import SwiftUI

struct FlashCardListRowView: View {
    @EnvironmentObject var model: WordAXModelView
    var flashcard: Flashcard
    @State var favorite = true
    var body: some View {
        HStack {
            Group {
                if favorite {
                    Image(systemName: "star")
                } else {
                    ZStack {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Image(systemName: "star")
                            .opacity(0.4)
                    }
                }
            }
            .onTapGesture {
                self.favorite = !self.favorite
            }
            .padding(.trailing)
            VStack {
                Text(flashcard.name ?? "Unknown")
                    .bold()
                    .font(.system(size: 19))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(flashcard.desc ?? "Unknown")
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
            }
        }
        
    }
}

#Preview {
    let flashcard = try? DataController.preview.viewContext.fetch(Flashcard.fetchRequest()).first
    return Group {
        FlashCardListRowView(flashcard: flashcard!)
            .environmentObject(WordAXModelView())
            .environment(\.managedObjectContext, DataController.preview.container.viewContext)
        FlashCardListRowView(flashcard: flashcard!)
            .environmentObject(WordAXModelView())
            .environment(\.managedObjectContext, DataController.preview.container.viewContext)
        FlashCardListRowView(flashcard: flashcard!)
            .environmentObject(WordAXModelView())
            .environment(\.managedObjectContext, DataController.preview.container.viewContext)
    }
}
