//
//  DataController.swift
//  WordAX
//
//  Created by Oliver Hnát on 08.04.2024.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "WordAXCD")
//    static let shared = DataController()
    typealias SpacedRepetitionMilestoneEnum = Flashcard.SpacedRepetitionMilestoneEnum
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    //    public func addFlashcard(name: String, description: String) {
    public func addFlashcard(name: String, description: String) {
        let flashcard = Flashcard(context: viewContext)
        flashcard.id = UUID()
        flashcard.name = name
        flashcard.desc = description
        flashcard.shown = false
        flashcard.nextSpacedRepetitionMilestone = 0
        flashcard.lastSeenOn = nil
        flashcard.shownCount = 0
        flashcard.dateAdded = Date()
        try? viewContext.save()
    }
    
    // TODO: Figure out if this does anything?
    public func setNextSpacedRepetitionMilestone(flashcard: Flashcard) {
        let current = SpacedRepetitionMilestoneEnum.allCasesSorted.firstIndex(of: flashcard.getSpacedRepetitionMilestone()) ?? SpacedRepetitionMilestoneEnum.allCases.count
        let predicate = NSPredicate(format: "id == %@", flashcard.id! as CVarArg)
        let flashcards = self.getAllFlashcards(predicate: predicate)
        if !flashcards.isEmpty {
            if current + 1 < SpacedRepetitionMilestoneEnum.allCases.count {
                flashcards[0].nextSpacedRepetitionMilestone = SpacedRepetitionMilestoneEnum.allCasesSorted[current + 1].rawValue
            }
        }
    }
    
    public func setSpacedRepetitionMilestone(flashcardId: UUID, milestone: SpacedRepetitionMilestoneEnum?) {
        let predicate = NSPredicate(format: "id == %@", flashcardId as CVarArg)
        let flashcards = self.getAllFlashcards(predicate: predicate)
        if !flashcards.isEmpty {
            if milestone != nil {
                flashcards[0].nextSpacedRepetitionMilestone = milestone!.rawValue
            } else {
                flashcards[0].nextSpacedRepetitionMilestone = 0
            }
            if !flashcards[0].shown {
                flashcards[0].shown = true
            }
            flashcards[0].lastSeenOn = Date()
        }
    }
    
    public func flashcardShown(flashcardId: UUID) {
        let predicate = NSPredicate(format: "id == %@", flashcardId as CVarArg)
        let flashcards = self.getAllFlashcards(predicate: predicate)
        if !flashcards.isEmpty {
            flashcards[0].shownCount += 1
            try? viewContext.save()
        }
    }
    
    public func getAllFlashcards(predicate: NSPredicate? = nil) -> [Flashcard]{
        let request = NSFetchRequest<Flashcard>(entityName: "Flashcard")
        if predicate != nil {
            request.predicate = predicate
        }
        
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
//    public func getFlashCardsToDisplay() -> Flashcard? {
//        let flashcards = self.getAllFlashcards()
//        
//        if flashcards.count > 0 {
//            let notShownFlashCards = flashcards.filter({!$0.shown})
//            // if today is the date they're supposed to be shown
//            
//            let displayToday = flashcards.filter({
//                $0.lastSeenOn != nil &&
//                $0.lastSeenOn!.addSpacedRepetitionMilestone(
//                    milestone: SpacedRepetitionMilestoneEnum.getMilestoneFromInt(
//                            value: $0.nextSpacedRepetitionMilestone))
//                                .isBeforeTodayOrToday()
//            })
//            if  displayToday.count > 0 {
//                return displayToday.first!
//            }
//            
////            let shownWords = words.filter({ $0.shown })
////            if shownWords.count == 0 {
//            if notShownFlashCards.count == 0 {
//                return nil
//            }
//            return notShownFlashCards.sorted(by: {$0.id < $1.id}).first
////            }
//            // if today is the day to show a new word
////            let settings = model.settings
////            if shownWords.count == 0 ||
////                settings.lastShownNew == nil ||
////                settings.lastShownNew!.addFrequency(frequency: settings.frequency).isAfterToday() {
////                return words.first!
////            }
//        }
//        // otherwise show nothing
//        return nil
//    }
}
