//
//  AnkiView.swift
//  WordAX
//
//  Created by Oliver Hnát on 23.02.2024.
//

import SwiftUI
import CoreData

struct AnkiView: View {
    @EnvironmentObject var model: WordAXModelView
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(key: "nextSpacedRepetitionMilestone", ascending: false),
        NSSortDescriptor(key: "lastSeenOn", ascending: true)
    ], predicate: NSCompoundPredicate(type: .or, subpredicates: [
        NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "%K != nil", "lastSeenOn"),
            NSPredicate(format: "lastSeenOn + nextSpacedRepetitionMilestone < %@", Date() as CVarArg)
        ]),
        NSPredicate(format: "lastSeenOn == nil")
    ])) var flashcards: FetchedResults<Flashcard>
    
    @State var showDescription = false
    
    var body: some View {
        if !flashcards.isEmpty && flashcards.first != nil {
            GeometryReader { geometry in
                VStack {
                    if flashcards.first != nil {
                        FlashCardView(flashcard: flashcards.first!, showDescription: $showDescription)
                    }
                    if showDescription && flashcards.first != nil {
                        //                    Text("How did you do?")
                        //                        .font(.subheadline)
                        //                        .foregroundStyle(.gray)
                        HStack(alignment: .center) {
                            // TODO: Maybe create an algorithm to take into account the shownCount and not just always restart from 1 min?
                            NextRepetitionButtonView(
                                buttonText: "Wrong",
                                nextMilestone: DataController.SpacedRepetitionMilestoneEnum.OneMinute,
                                flashcardId: flashcards.first!.id!,
                                width: geometry.size.width,
                                color: .red,
                                geometry: geometry,
                                timeText: DataController.SpacedRepetitionMilestoneEnum.OneMinute.rawValue.convertDurationSecondsToString(),
                                showDescription: $showDescription
                            )
                            NextRepetitionButtonView(
                                buttonText: "Correct",
                                nextMilestone: flashcards.first!.getSpacedRepetitionMilestone(),
                                flashcardId: flashcards.first!.id!,
                                width:geometry.size.width,
                                color: .orange,
                                geometry: geometry,
                                timeText: flashcards.first!.getSpacedRepetitionMilestone().rawValue.convertDurationSecondsToString(),
                                showDescription: $showDescription
                            )
                            NextRepetitionButtonView(
                                buttonText: "Easy",
                                nextMilestone: Flashcard.SpacedRepetitionMilestoneEnum.getNext(milestone: flashcards.first!.getSpacedRepetitionMilestone()),
                                flashcardId: flashcards.first!.id!,
                                width: geometry.size.width,
                                color: .green,
                                geometry: geometry,
                                timeText: Flashcard.SpacedRepetitionMilestoneEnum.getNext(milestone: flashcards.first!.getSpacedRepetitionMilestone()).rawValue.convertDurationSecondsToString(),
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
        .environment(\.managedObjectContext, DataController.preview.container.viewContext)
}
