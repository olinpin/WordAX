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
    
    @State private var timeRemaining = 10
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var sortedFlashcards: [Flashcard] = []
    
    @Environment(\.colorScheme) var colorScheme

    
    // get the most recent flashcard
    @FetchRequest(sortDescriptors: [],
          predicate: NSPredicate(format: "%K != nil", "lastSeenOn")) var soonestFlashcard: FetchedResults<Flashcard>

    
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
            if !soonestFlashcard.isEmpty {
                Text("Next flashcard in: \(timeRemaining.convertDurationSecondsToCountdown())")
                    .foregroundStyle(.black)
                    .padding()
                    .background(.yellow)
                    .clipShape(.buttonBorder)
                    .padding(.vertical, 50)
                    .padding(.horizontal)
                    .background(.gray.opacity(0.3))
                    .clipShape(.buttonBorder)
                    .onAppear {
                        if !soonestFlashcard.isEmpty {
                            sortedFlashcards = soonestFlashcard.sorted(by: {
                                ($0.lastSeenOn!.addSpacedRepetitionMilestone(milestone:$0.getSpacedRepetitionMilestone()).timeIntervalSinceNow) < ($1.lastSeenOn!.addSpacedRepetitionMilestone(milestone: $1.getSpacedRepetitionMilestone()).timeIntervalSinceNow)
                            })
                            timeRemaining = Int(sortedFlashcards.first!.lastSeenOn!.addSpacedRepetitionMilestone(milestone:sortedFlashcards.first!.getSpacedRepetitionMilestone()).timeIntervalSinceNow)
                        }
                    }
                    .onReceive(timer) { time in
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        }
                    }
            }
        }
    }
}

#Preview {
    AnkiView()
        .environmentObject(WordAXModelView())
        .environment(\.managedObjectContext, DataController.preview.container.viewContext)
}
