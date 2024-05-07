//
//  Flashcard+CoreDataProperties.swift
//  WordAX
//
//  Created by Oliver Hnát on 11.04.2024.
//
//

import Foundation
import CoreData


extension Flashcard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Flashcard> {
        return NSFetchRequest<Flashcard>(entityName: "Flashcard")
    }

    @NSManaged public var dateAdded: Date?
    @NSManaged public var desc: String?
    @NSManaged public var favorite: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var lastSeenOn: Date?
    @NSManaged public var name: String?
    @NSManaged public var nextSpacedRepetitionMilestone: Int64
    @NSManaged public var shown: Bool
    @NSManaged public var shownCount: Int64
    @NSManaged public var deck: Deck?
    @NSManaged public var hint: String?

}

extension Flashcard : Identifiable {

}
