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
