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
    
    static var preview: DataController = {
        let result = DataController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let flashcard = Flashcard(context: viewContext)
            flashcard.id = UUID()
            flashcard.name = ["This is a name", "This is another name", "This is a third name", "This is a fourth name"].randomElement()!
            flashcard.desc = [
                "This is a very long description that should be even longer maybe even lorem ipsum to cover all cases?",
                "This is a very short description",
                "This is a medium length description that should be long enough to cover all cases"
            ].randomElement()!
            flashcard.nextSpacedRepetitionMilestone = SpacedRepetitionMilestoneEnum.allCases.randomElement()!.rawValue
            flashcard.lastSeenOn  = [nil, Date(), Date().addingTimeInterval([-86400, -24000, -100000].randomElement()!)].randomElement()!
            flashcard.shownCount = [0, 1, 2, 3, 4, 5].randomElement()!
            flashcard.dateAdded = [Date(), Date().addingTimeInterval(-86400), Date().addingTimeInterval(-172800)].randomElement()!
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    
    init(inMemory: Bool = false) {
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
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
