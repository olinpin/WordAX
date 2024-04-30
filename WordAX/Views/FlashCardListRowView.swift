//
//  WordListRowView.swift
//  WordAX
//
//  Created by Oliver Hnát on 25.02.2024.
//

import SwiftUI

struct FlashCardListRowView: View {
    @State var flashcard: Flashcard
    @State private var refresh: UUID = UUID()
    var body: some View {
        HStack {
            Group {
                if !flashcard.favorite {
                    Image(systemName: "star")
                } else {
                    ZStack {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Image(systemName: "star")
                            .opacity(0)
                    }
                }
            }
            .onTapGesture {
                flashcard.favorite.toggle()
                do {
                    try flashcard.managedObjectContext?.save()
                } catch {
                    print("Something went wrong while saving favorite cards, please try again")
                }
                refresh = UUID()
            }
            .id(refresh)
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
