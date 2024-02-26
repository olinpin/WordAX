//
//  AnkiView.swift
//  WordAX
//
//  Created by Oliver Hnát on 23.02.2024.
//

import SwiftUI

struct AnkiView: View {
    @EnvironmentObject var model: WordAXModelView
    @State var showDescription = false
    var word: WordAX.Word? {
        model.getWordToDisplay()
    }
    var body: some View {
        if word != nil {
            VStack {
                WordView(word: word!, showDescription: $showDescription)
                if showDescription {
//                    Text("How did you do?")
//                        .font(.subheadline)
//                        .foregroundStyle(.gray)
                        HStack(alignment: .center) {
                            NextRepetitionButtonView(buttonText: "Novice", nextMilestone: WordAX.SpacedRepetitionMilestoneEnum.getNext(milestone: WordAX.SpacedRepetitionMilestoneEnum.getNext(milestone: word!.nextSpacedRepetitionMilestone)), wordId: word!.id, showDescription: $showDescription)
                            //                            .padding(.leading)
                            NextRepetitionButtonView(buttonText: "Expert", nextMilestone: WordAX.SpacedRepetitionMilestoneEnum.getNext(milestone: word!.nextSpacedRepetitionMilestone), wordId: word!.id, showDescription: $showDescription)
                            NextRepetitionButtonView(buttonText: "Master", nextMilestone: word!.nextSpacedRepetitionMilestone, wordId: word!.id, showDescription: $showDescription)
                            //                            .padding(.trailing)
                        }
                        .padding([.bottom, .trailing, .leading])
                }
            }
        } else {
            Text("There is no word to display, come back later")
        }
    }
}

#Preview {
    AnkiView()
        .environmentObject(WordAXModelView())
}
