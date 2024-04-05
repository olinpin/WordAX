//
//  AnkiView.swift
//  WordAX
//
//  Created by Oliver Hnát on 23.02.2024.
//

import SwiftUI

struct AnkiView: View {
    @EnvironmentObject var model: WordAXModelView
    @State var showDescription = true
    var word: WordAX.Word? {
        model.getWordToDisplay()
    }
    var body: some View {
        if word != nil {
            GeometryReader { geometry in
                VStack {
                    WordView(word: word!, showDescription: $showDescription)
                    if showDescription {
                        //                    Text("How did you do?")
                        //                        .font(.subheadline)
                        //                        .foregroundStyle(.gray)
                        HStack(alignment: .center) {
                            NextRepetitionButtonView(
                                buttonText: "Easy",
                                nextMilestone: WordAX.SpacedRepetitionMilestoneEnum.getNext(milestone: WordAX.SpacedRepetitionMilestoneEnum.getNext(milestone: word!.nextSpacedRepetitionMilestone)),
                                wordId: word!.id,
                                width: geometry.size.width,
                                color: .green,
                                geometry: geometry,
                                showDescription: $showDescription)
                            NextRepetitionButtonView(
                                buttonText: "Normal",
                                nextMilestone: WordAX.SpacedRepetitionMilestoneEnum.getNext(milestone: word!.nextSpacedRepetitionMilestone),
                                wordId: word!.id,
                                width:geometry.size.width,
                                color: .orange,
                                geometry: geometry,
                                showDescription: $showDescription)
                            NextRepetitionButtonView(
                                buttonText: "Hard",
                                nextMilestone: word!.nextSpacedRepetitionMilestone,
                                wordId: word!.id,
                                width: geometry.size.width,
                                color: .red,
                                geometry: geometry,
                                showDescription: $showDescription)
                        }
                        .padding([.bottom, .trailing, .leading])
                    }
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
