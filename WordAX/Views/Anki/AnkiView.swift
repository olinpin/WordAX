//
//  AnkiView.swift
//  WordAX
//
//  Created by Oliver Hnát on 23.02.2024.
//

import SwiftUI
import CoreData

struct AnkiView: View {
    @Environment(\.managedObjectContext) var moc
    
    @State private var timeRemaining = 10
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var flashcards: [Flashcard] = []
    @State var soonestFlashcards: [Flashcard] = []
    @State var showDescription = false
    
    var body: some View {
        Group {
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
                            ButtonHStackView(flashcard: flashcards.first!, geometry: geometry, reload: refreshFlashcards, showDescription: $showDescription)
                                .padding([.bottom, .trailing, .leading])
                        }
                    }
                }
            } else {
                if !soonestFlashcards.isEmpty {
                    Group {
                        Text("Next flashcard in: \(timeRemaining.convertDurationSecondsToCountdown())")
                            .foregroundStyle(.black)
                            .padding()
                            .frame(maxWidth: .infinity - 50)
                            .background(.yellow)
                            .clipShape(.buttonBorder)
                            .padding(.vertical, 50)
                            .padding(.horizontal)
                            .onReceive(timer) { time in
                                if timeRemaining > 1 {
                                    timeRemaining -= 1
                                }
                                if timeRemaining <= 3 {
                                    refreshFlashcards()
                                }
                            }
                            .background(.gray.opacity(0.3))
                            .clipShape(.buttonBorder)
                            .padding(.horizontal)
                    }
                }
                else {
                    Text("No flashcards available")
                        .foregroundStyle(.black)
                        .padding()
                    //                    .frame(maxWidth: .infinity - 50)
                        .background(.yellow)
                        .clipShape(.buttonBorder)
                        .padding(.vertical, 50)
                        .padding(.horizontal)
                }
            }
        }
        .onAppear {
            refreshFlashcards()
        }
    }
    
    func refreshFlashcards() {
        let requestAllFlashcards = NSFetchRequest<Flashcard>(entityName: "Flashcard")
        requestAllFlashcards.predicate = NSCompoundPredicate(type: .or, subpredicates: [
            NSCompoundPredicate(type: .and, subpredicates: [
                NSPredicate(format: "%K != nil", "lastSeenOn"),
                NSPredicate(format: "lastSeenOn + nextSpacedRepetitionMilestone < %@", Date() as CVarArg)
            ]),
            NSPredicate(format: "lastSeenOn == nil")
        ])
        requestAllFlashcards.sortDescriptors = [
            NSSortDescriptor(key: "nextSpacedRepetitionMilestone", ascending: false),
            NSSortDescriptor(key: "lastSeenOn", ascending: true)
        ]
        do {
            flashcards = try moc.fetch(requestAllFlashcards)
        } catch {
            print("Something went wrong while fetching available flashcards")
        }
        
        
        
        let requestSoonestFlashcards = NSFetchRequest<Flashcard>(entityName: "Flashcard")
        requestSoonestFlashcards.predicate = NSPredicate(format: "%K != nil", "lastSeenOn")
        do {
            soonestFlashcards = try moc.fetch(requestSoonestFlashcards)
//            print("This is soonest flashcards")
//            for flashcard in soonestFlashcards {
//                print("\(flashcard.name ?? "") is \(Int(flashcard.lastSeenOn!.addSpacedRepetitionMilestone(milestone:flashcard.getSpacedRepetitionMilestone()).timeIntervalSinceNow.rounded()))")
//            }
        } catch {
            print("Something went wrong while fetching latest flashcard")
        }
        if !soonestFlashcards.isEmpty {
            soonestFlashcards = soonestFlashcards.sorted {
                if $0.lastSeenOn != nil && $1.lastSeenOn != nil {
                    return $0.lastSeenOn!.addSpacedRepetitionMilestone(milestone:$0.getSpacedRepetitionMilestone()).timeIntervalSinceNow < $1.lastSeenOn!.addSpacedRepetitionMilestone(milestone: $1.getSpacedRepetitionMilestone()).timeIntervalSinceNow
                } else {
                    return $0.lastSeenOn != nil
                }
            }
            if soonestFlashcards.first!.lastSeenOn != nil {
                timeRemaining = Int(soonestFlashcards.first!.lastSeenOn!.addSpacedRepetitionMilestone(milestone:soonestFlashcards.first!.getSpacedRepetitionMilestone()).timeIntervalSinceNow.rounded())
            } else {
                print("Something went wrong while getting latest flashcard")
            }
        }
    }
}

#Preview {
    AnkiView()
        .environment(\.managedObjectContext, DataController.preview.container.viewContext)
}
