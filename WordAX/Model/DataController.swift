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
    typealias SpacedRepetitionMilestoneEnum = Flashcard.SpacedRepetitionMilestoneEnum
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    static var preview: DataController = {
        let result = DataController(inMemory: true)
        let viewContext = result.container.viewContext
        var decks: [Deck] = []
        var deck = Deck(context: viewContext)
        deck.id = UUID()
        deck.name = "This is a deck name"
        deck.dateAdded = Date()
        decks.append(deck)
        
        deck = Deck(context: viewContext)
        deck.id = UUID()
        deck.name = "Another Deck"
        deck.dateAdded = Date().addingTimeInterval(-86400)
        decks.append(deck)

        deck = Deck(context: viewContext)
        deck.id = UUID()
        deck.name = "Deck"
        deck.dateAdded = Date().addingTimeInterval(-86400 * 2)
        decks.append(deck)
        
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
            flashcard.lastSeenOn = [nil, Date(), Date().addingTimeInterval([-86400, -24000, -100000].randomElement()!)].randomElement()!
            flashcard.shownCount = [0, 1, 2, 3, 4, 5].randomElement()!
            flashcard.dateAdded = [Date(), Date().addingTimeInterval(-86400), Date().addingTimeInterval(-172800)].randomElement()!
            flashcard.favorite = [true, false].randomElement()!
            flashcard.deck = decks.randomElement()
            flashcard.hint = ["This is a small hint", "Hint", "This is a very long hint that maybe should be even longer olorem ipsum to cover everything but I don't know what else to write Lorem Ipsum", "This is something in between hint that doesn'coveres the mid cases Lorem Ipsujm Lor"].randomElement()
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
        if days == 0 && hours == 0 && minutes == 0 {
            return "\(seconds)s"
        }
        
        return result
        
    }
}
