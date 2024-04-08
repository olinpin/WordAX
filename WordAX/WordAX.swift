//
//  WordAX.swift
//  WordAX
//
//  Created by Oliver Hnát on 23.02.2024.
//

import Foundation
import SwiftUI

struct WordAX {
    struct FlashCard: Identifiable, Hashable {
        var id: Int
        var name: String
        var description: String
        var shown: Bool = false
        var nextSpacedRepetitionMilestone: SpacedRepetitionMilestoneEnum?
        var lastSeenOn: Date?
        var shownCount: Int = 0
    }
    
    enum FrequencyEnum: Int {
        case Daily = 1
        case Weekly = 7
        case BiWeekly = 14
        case Monthly = 30
    }
    
    
    public mutating func add(flashcard: FlashCard) {
        self.flashcards.append(flashcard)
    }


    @objc enum SpacedRepetitionMilestoneEnum: Int64, CaseIterable {
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
        
        static func getNext(milestone: SpacedRepetitionMilestoneEnum?) -> SpacedRepetitionMilestoneEnum? {
            let sorted = WordAX.SpacedRepetitionMilestoneEnum.allCasesSorted
            if milestone == nil {
                return sorted.first
            }
            let milestoneIndex = sorted.firstIndex(where: {$0.rawValue == milestone!.rawValue})!
            if milestoneIndex < WordAX.SpacedRepetitionMilestoneEnum.allCasesSorted.count {
                return sorted[milestoneIndex + 1]
            }
            return nil
        }

        static func getMilestoneFromInt(value: Int64) -> SpacedRepetitionMilestoneEnum {
            return SpacedRepetitionMilestoneEnum.allCasesSorted.first(where: {$0.rawValue == value}) ?? SpacedRepetitionMilestoneEnum.Now
        }
        
    }
    
    struct Settings {
        var frequency: FrequencyEnum = .Daily
        var lastShownNew: Date?
        var dateFormatter: DateFormatter
    }
    
    public mutating func setNextSpacedRepetitionMilestone(flashcard: FlashCard) {
        if flashcard.nextSpacedRepetitionMilestone != nil {
            let current = SpacedRepetitionMilestoneEnum.allCasesSorted.firstIndex(of: flashcard.nextSpacedRepetitionMilestone!) ?? SpacedRepetitionMilestoneEnum.allCases.count
            let index = flashcards.firstIndex(where:{$0.id == flashcard.id}) ?? nil
            if current + 1 < SpacedRepetitionMilestoneEnum.allCases.count && index != nil {
                flashcards[index!].nextSpacedRepetitionMilestone = SpacedRepetitionMilestoneEnum.allCasesSorted[current + 1]
            } else if index != nil {
                flashcards[index!].nextSpacedRepetitionMilestone = nil
            }
        }
    }
    
    public mutating func setSpacedRepetitionMilestone(flashcardId: Int, milestone: SpacedRepetitionMilestoneEnum?) {
        let index = flashcards.firstIndex(where:{$0.id == flashcardId}) ?? nil
        if index != nil {
            flashcards[index!].nextSpacedRepetitionMilestone = milestone
            if !flashcards[index!].shown {
                flashcards[index!].shown = true
            }
            flashcards[index!].lastSeenOn = Date()
        }
    }
    
    public mutating func flashcardShown(flashcardId: Int) {
        let index = flashcards.firstIndex(where:{$0.id == flashcardId}) ?? nil
        if index != nil {
            flashcards[index!].shownCount += 1
        }
        
    }
    
    var flashcards: [FlashCard] = []
    var settings: Settings
    
    init() {
        self.flashcards = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        self.settings = Settings(dateFormatter: dateFormatter)
//        self.flashcards.append(FlashCard(id: 0, name: "Magnificent", description: "When something is awesome. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", shown: false))
//        self.flashcards.append(FlashCard(id: 1, name: "Mesmerising", description: "When something is beautiful", shown: false))
    }
    
}
