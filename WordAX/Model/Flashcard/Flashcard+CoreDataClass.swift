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
    enum SpacedRepetitionMilestoneEnum: Int64, CaseIterable {
        case Now = 0 // starting value
        case OneMinute = 60 // 60 * 1
        case TenMinutes = 600 // 60 * 10
        case OneHour = 3600 // 60 * 60
        case OneDay = 86_400 // 24 * 60 * 60
        case OneWeek = 604_800 // 24 * 60 * 60 * 7
        case TwoWeeks = 1_209_600 // 24 * 60 * 60 * 14
        case OneMonth = 2_592_000 // 24 * 60 * 60 * 30
        case TwoMonths = 5_184_000 // 24 * 60 * 60 * 60
        case FiveMonths = 12_960_000 // 24 * 60 * 60 * 150
        case OneYear = 31_536_000 // 24 * 60 * 60 * 365
        
        static var allCasesSorted: [SpacedRepetitionMilestoneEnum] {
            allCases.sorted {$0.rawValue < $1.rawValue }
        }
        
        static func getNext(milestone: SpacedRepetitionMilestoneEnum?) -> SpacedRepetitionMilestoneEnum {
            let sorted = SpacedRepetitionMilestoneEnum.allCasesSorted
            if milestone == nil {
                return .TenMinutes
            }
            let milestoneIndex = sorted.firstIndex(where: {$0.rawValue == milestone!.rawValue})!
            if milestoneIndex < sorted.count {
                // 1 minute is only if answer was wrong, so 10 minutes is the first valid milestone
                return sorted[milestoneIndex + 1] == .OneMinute ? .TenMinutes : sorted[milestoneIndex + 1]
            }
            return .OneYear
        }
        
        static func getMilestoneFromInt(value: Int64) -> SpacedRepetitionMilestoneEnum {
            return .allCasesSorted.first(where: {$0.rawValue == value}) ?? .Now
        }
        
    }
    
    func getSpacedRepetitionMilestone() -> SpacedRepetitionMilestoneEnum {
        let milestone = SpacedRepetitionMilestoneEnum.getMilestoneFromInt(value: self.nextSpacedRepetitionMilestone)
        return milestone == .Now || milestone == .OneMinute ? .TenMinutes : milestone
    }
}
