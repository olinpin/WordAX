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
    static let shared = DataController()
    
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
    
    public func getAllFlashcards() -> [Flashcard]{
        let request = NSFetchRequest<Flashcard>(entityName: "Flashcard")
        
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
}
