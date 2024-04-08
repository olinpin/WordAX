//
//  Flashcard+CoreDataClass.swift
//  WordAX
//
//  Created by Oliver Hnát on 08.04.2024.
//
//

import Foundation
import CoreData

@objc(Flashcard)
public class Flashcard: NSManagedObject {
    typealias SpacedRepetitionMilestoneEnum = WordAX.SpacedRepetitionMilestoneEnum
    
    func getSpacedRepetitionMilestone() -> SpacedRepetitionMilestoneEnum {
        return SpacedRepetitionMilestoneEnum.getMilestoneFromInt(value: self.nextSpacedRepetitionMilestone)
    }
}
