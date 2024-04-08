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
    var flashcard: Flashcard? {
        model.getFlashCardsToDisplay()
    }
    var body: some View {
        if flashcard != nil {
            GeometryReader { geometry in
                VStack {
                    FlashCardView(flashcard: flashcard!, showDescription: $showDescription)
                    if showDescription {
                        //                    Text("How did you do?")
                        //                        .font(.subheadline)
                        //                        .foregroundStyle(.gray)
                        HStack(alignment: .center) {
                            NextRepetitionButtonView(
                                buttonText: "Wrong",
                                nextMilestone: flashcard!.getSpacedRepetitionMilestone(),
                                flashcardId: flashcard!.id!,
                                width: geometry.size.width,
                                color: .red,
                                geometry: geometry,
                                timeText: "1m",
                                showDescription: $showDescription
                            )
                            NextRepetitionButtonView(
                                buttonText: "Correct",
                                nextMilestone: WordAX.SpacedRepetitionMilestoneEnum.getNext(milestone: flashcard!.getSpacedRepetitionMilestone()),
                                flashcardId: flashcard!.id!,
                                width:geometry.size.width,
                                color: .orange,
                                geometry: geometry,
                                timeText: "10m",
                                showDescription: $showDescription
                            )
                            NextRepetitionButtonView(
                                buttonText: "Easy",
                                nextMilestone: WordAX.SpacedRepetitionMilestoneEnum.getNext(milestone: WordAX.SpacedRepetitionMilestoneEnum.getNext(milestone: flashcard!.getSpacedRepetitionMilestone())),
                                flashcardId: flashcard!.id!,
                                width: geometry.size.width,
                                color: .green,
                                geometry: geometry,
                                timeText: "1h",
                                showDescription: $showDescription
                            )
                        }
                        .padding([.bottom, .trailing, .leading])
                    }
                }
            }
        } else {
            Text("There are currently no words to display")
                .padding()
                .background(.yellow)
                .clipShape(.buttonBorder)
        }
    }
}

#Preview {
    AnkiView()
        .environmentObject(WordAXModelView())
}
