//
//  ButtonHStackView.swift
//  WordAX
//
//  Created by Oliver Hnát on 12.04.2024.
//

import SwiftUI

struct ButtonHStackView: View {
    let flashcard: Flashcard
    let geometry: GeometryProxy
    @Binding var showDescription: Bool
    var body: some View {
        HStack(alignment: .center) {
            // TODO: Maybe create an algorithm to take into account the shownCount and not just always restart from 1 min?
            NextRepetitionButtonView(
                buttonText: "Wrong",
                nextMilestone: DataController.SpacedRepetitionMilestoneEnum.OneMinute,
                flashcardId: flashcard.id!,
                color: .red,
                geometry: geometry,
                timeText: DataController.SpacedRepetitionMilestoneEnum.OneMinute.rawValue.convertDurationSecondsToString(),
                showDescription: $showDescription
            )
            NextRepetitionButtonView(
                buttonText: "Correct",
                nextMilestone: flashcard.getSpacedRepetitionMilestone(),
                flashcardId: flashcard.id!,
                color: .orange,
                geometry: geometry,
                timeText: flashcard.getSpacedRepetitionMilestone().rawValue.convertDurationSecondsToString(),
                showDescription: $showDescription
            )
            NextRepetitionButtonView(
                buttonText: "Easy",
                nextMilestone: Flashcard.SpacedRepetitionMilestoneEnum.getNext(milestone: flashcard.getSpacedRepetitionMilestone()),
                flashcardId: flashcard.id!,
                color: .green,
                geometry: geometry,
                timeText: Flashcard.SpacedRepetitionMilestoneEnum.getNext(milestone: flashcard.getSpacedRepetitionMilestone()).rawValue.convertDurationSecondsToString(),
                showDescription: $showDescription
            )
        }
    }
}

//#Preview {
//    ButtonHStackView()
//}
