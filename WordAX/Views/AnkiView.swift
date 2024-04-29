//
//  AnkiView.swift
//  WordAX
//
//  Created by Oliver Hnát on 23.02.2024.
//

import SwiftUI
import CoreData

struct AnkiView: View {
    //    @EnvironmentObject var model: WordAXModelView
    @Environment(\.managedObjectContext) var moc
    
    // get flashcards to display
    //    @FetchRequest(sortDescriptors: [
    //        NSSortDescriptor(key: "nextSpacedRepetitionMilestone", ascending: false),
    //        NSSortDescriptor(key: "lastSeenOn", ascending: true)
    //    ], predicate: NSCompoundPredicate(type: .or, subpredicates: [
    //        NSCompoundPredicate(type: .and, subpredicates: [
    //            NSPredicate(format: "%K != nil", "lastSeenOn"),
    //            NSPredicate(format: "lastSeenOn + nextSpacedRepetitionMilestone < %@", Date() as CVarArg)
    //        ]),
    //        NSPredicate(format: "lastSeenOn == nil")
    //    ])) var flashcards: FetchedResults<Flashcard>
    
    // get the most recent flashcard
    //    @FetchRequest(sortDescriptors: [],
    //                  predicate: NSPredicate(format: "%K != nil", "lastSeenOn")) var soonestFlashcard: FetchedResults<Flashcard>
    
    @State private var timeRemaining = 10
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var flashcards: [Flashcard] = []
    @State var sortedFlashcards: [Flashcard] = []
    @State var soonestFlashcard: [Flashcard] = []
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
                            ButtonHStackView(flashcard: flashcards.first!, geometry: geometry, showDescription: $showDescription)
                                .padding([.bottom, .trailing, .leading])
                        }
                    }
                }
            } else {
                if !soonestFlashcard.isEmpty {
                    Group {
                        Text("Next flashcard in: \(timeRemaining.convertDurationSecondsToCountdown())")
                            .foregroundStyle(.black)
                            .padding()
                            .frame(maxWidth: .infinity - 50)
                            .background(.yellow)
                            .clipShape(.buttonBorder)
                            .padding(.vertical, 50)
                            .padding(.horizontal)
                            .onAppear {
                                if !soonestFlashcard.isEmpty {
                                    sortedFlashcards = soonestFlashcard.sorted(by: {
                                        ($0.lastSeenOn!.addSpacedRepetitionMilestone(milestone:$0.getSpacedRepetitionMilestone()).timeIntervalSinceNow) < ($1.lastSeenOn!.addSpacedRepetitionMilestone(milestone: $1.getSpacedRepetitionMilestone()).timeIntervalSinceNow)
                                    })
                                    timeRemaining = Int(sortedFlashcards.first!.lastSeenOn!.addSpacedRepetitionMilestone(milestone:sortedFlashcards.first!.getSpacedRepetitionMilestone()).timeIntervalSinceNow)
                                }
                                refreshFlashcards()
                            }
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
        let request = NSFetchRequest<Flashcard>(entityName: "Flashcard")
        request.predicate = NSCompoundPredicate(type: .or, subpredicates: [
            NSCompoundPredicate(type: .and, subpredicates: [
                NSPredicate(format: "%K != nil", "lastSeenOn"),
                NSPredicate(format: "lastSeenOn + nextSpacedRepetitionMilestone < %@", Date() as CVarArg)
            ]),
            NSPredicate(format: "lastSeenOn == nil")
        ])
        request.sortDescriptors = [
            NSSortDescriptor(key: "nextSpacedRepetitionMilestone", ascending: false),
            NSSortDescriptor(key: "lastSeenOn", ascending: true)
        ]
        do {
            flashcards = try moc.fetch(request)
        } catch {
            print("Something went wroooong")
        }
        
        
        
        let req = NSFetchRequest<Flashcard>(entityName: "Flashcard")
        req.predicate = NSPredicate(format: "%K != nil", "lastSeenOn")
        do {
            soonestFlashcard = try moc.fetch(request)
        } catch {
            print("Something went bum")
        }
    }
}

#Preview {
    AnkiView()
        .environmentObject(WordAXModelView())
        .environment(\.managedObjectContext, DataController.preview.container.viewContext)
}
