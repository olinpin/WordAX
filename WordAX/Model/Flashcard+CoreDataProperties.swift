//
//  Flashcard+CoreDataProperties.swift
//  WordAX
//
//  Created by Oliver Hnát on 08.04.2024.
//
//

import Foundation
import CoreData


extension Flashcard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Flashcard> {
        return NSFetchRequest<Flashcard>(entityName: "Flashcard")
    }

    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var id: UUID?
    @NSManaged public var shown: Bool
    @NSManaged public var nextSpacedRepetitionMilestone: Int64
    @NSManaged public var lastSeenOn: Date?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var shownCount: Int64

}

extension Flashcard : Identifiable {

}
