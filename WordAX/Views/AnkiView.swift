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
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(key: "calculatedNextRepetition", ascending: false)
        ],
          predicate:
            NSCompoundPredicate(type: .and, subpredicates: [
                NSPredicate(format: "%K != nil", "lastSeenOn"),
            NSPredicate(
                format: "lastSeenOn + nextSpacedRepetitionMilestone > %@", Date() as CVarArg)
                ]
    )) var soonestFlashcard: FetchedResults<Flashcard>

    // get the most recent flashcard
    
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
            // TODO: Add countdown to the next available word
            VStack{
                if !soonestFlashcard.isEmpty {
                    Text("Time: \(timeRemaining.convertDurationSecondsToCountdown())")
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(.black.opacity(0.75))
                        .clipShape(.capsule)
                }
                
//                if !soonestFlashcard.isEmpty {
//                    Text("HERE")
//                    Text("\(soonestFlashcard.first!.lastSeenOn!.addingTimeInterval(TimeInterval(soonestFlashcard.first!.nextSpacedRepetitionMilestone)).timeIntervalSince(Date()))")
//                    Text("\(Int64(timeRemaining))")
//                    Text("\(soonestFlashcard.first!.lastSeenOn!)")
//                    Text("\(soonestFlashcard.first!.getSpacedRepetitionMilestone().rawValue)")
//                    Text("\(soonestFlashcard.first!.lastSeenOn!.addSpacedRepetitionMilestone(milestone: soonestFlashcard.first!.getSpacedRepetitionMilestone()))")
//                }
//                if soonestFlashcard.first! {
//                    Text("HERE")
//                }
                
                Text("There are currently no words to display")
                    .padding()
                    .background(.yellow)
                    .clipShape(.buttonBorder)
            }
            .onAppear {
                if !soonestFlashcard.isEmpty {
                    var lastSeen = soonestFlashcard.first!.lastSeenOn!
                    var showIn = soonestFlashcard.first!.getSpacedRepetitionMilestone()
                    var show = lastSeen.addSpacedRepetitionMilestone(milestone: showIn)
                    timeRemaining = Int(show.timeIntervalSinceNow)
                }
            }
            .onReceive(timer) { time in
                if !soonestFlashcard.isEmpty {
                    var lastSeen = soonestFlashcard.first!.lastSeenOn!
                    var showIn = soonestFlashcard.first!.getSpacedRepetitionMilestone()
                    var show = lastSeen.addSpacedRepetitionMilestone(milestone: showIn)
                    timeRemaining = Int(show.timeIntervalSinceNow)
                }
//                timeRemaining = Int(soonestFlashcard.first!.lastSeenOn!.addSpacedRepetitionMilestone(milestone: soonestFlashcard.first!.getSpacedRepetitionMilestone()).timeIntervalSince(Date()))
//                timeRemaining = Int(soonestFlashcard.first!.lastSeenOn!.addingTimeInterval(TimeInterval(soonestFlashcard.first!.nextSpacedRepetitionMilestone)).timeIntervalSince(Date()))
//                if timeRemaining > 0 {
//                    timeRemaining -= 1
//                }
//                if !soonestFlashcard.isEmpty {
//                    timeRemaining = Int(Date().timeIntervalSince(soonestFlashcard.first!.lastSeenOn!))
//                }
            }
        }
    }
    @State private var timeRemaining = 10
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
}

#Preview {
    AnkiView()
        .environmentObject(WordAXModelView())
        .environment(\.managedObjectContext, DataController.preview.container.viewContext)
}
