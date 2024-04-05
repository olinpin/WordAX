//
//  WordListRowView.swift
//  WordAX
//
//  Created by Oliver Hnát on 25.02.2024.
//

import SwiftUI

struct WordListRowView: View {
    @EnvironmentObject var model: WordAXModelView
    var word: WordAX.Word
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
                Text(word.name)
                    .bold()
                    .font(.system(size: 19))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(word.description)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
            }
        }
        
    }
}

#Preview {
    Group {
        WordListRowView(word: WordAX.Word(id: 0, name: "Mesmerizing", description: "Some very long description like Lorem Ipsum which I'm to lazy to copy", shown: false, nextSpacedRepetitionMilestone: WordAX.SpacedRepetitionMilestoneEnum.OneDay, lastSeenOn: Date(), shownCount: 1))
            .environmentObject(WordAXModelView())
        WordListRowView(word: WordAX.Word(id: 0, name: "Mesmerizing", description: "Some very long description like Lorem Ipsum which I'm to lazy to copy", shown: false, nextSpacedRepetitionMilestone: WordAX.SpacedRepetitionMilestoneEnum.OneDay, lastSeenOn: Date(), shownCount: 1))
            .environmentObject(WordAXModelView())
        WordListRowView(word: WordAX.Word(id: 0, name: "Mesmerizing", description: "Some very long description like Lorem Ipsum which I'm to lazy to copy", shown: false, nextSpacedRepetitionMilestone: WordAX.SpacedRepetitionMilestoneEnum.OneDay, lastSeenOn: Date(), shownCount: 1))
            .environmentObject(WordAXModelView())
    }
}
