//
//  Deck+CoreDataProperties.swift
//  WordAX
//
//  Created by Oliver Hnát on 01.05.2024.
//
//

import Foundation
import CoreData


extension Deck {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Deck> {
        return NSFetchRequest<Deck>(entityName: "Deck")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var flashcards: NSSet?

}

// MARK: Generated accessors for flashcards
extension Deck {

    @objc(addFlashcardsObject:)
    @NSManaged public func addToFlashcards(_ value: Flashcard)

    @objc(removeFlashcardsObject:)
    @NSManaged public func removeFromFlashcards(_ value: Flashcard)

    @objc(addFlashcards:)
    @NSManaged public func addToFlashcards(_ values: NSSet)

    @objc(removeFlashcards:)
    @NSManaged public func removeFromFlashcards(_ values: NSSet)

}

extension Deck : Identifiable {

}
