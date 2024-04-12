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
}


extension Int64 {
    func convertDurationSecondsToString() -> String {
        var result = ""
        // Separate into days, hours, minutes and seconds and take the largest one
        let days: Int64 = self / 86400
        let hours: Int64 = self / 60 / 60 % 60
        let minutes: Int64 = self / 60 % 60
        let seconds: Int64 = self % 60
        if days > 0 {
            result = "\(days)d"
        } else if hours > 0 {
            result = "\(hours)h"
        } else if minutes > 0 {
            result = "\(minutes)min"
        } else if seconds > 0 {
            result = "\(seconds)s"
        } else {
            result = "\(self)"
        }

        return result
    }
}

extension Int {
    func convertDurationSecondsToCountdown() -> String {
        var result = ""
        // Separate into days, hours, minutes and seconds and take the largest one
        let days: Int = self / 86400
        let hours: Int = self / 60 / 60 % 60
        let minutes: Int = self / 60 % 60
        let seconds: Int = self % 60
        if days > 0 {
            result += "\(days)d"
        }
        if hours > 0 {
            result += " \(hours)h"
        }
        if minutes > 0 {
            result += " \(minutes)min"
        }
        if seconds > 0 {
            result += " \(seconds)s"
        }
//        else {
//            result = "\(self)"
//        }
        
        return result
        
    }
}
