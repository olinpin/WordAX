//
//  WordAX.swift
//  WordAX
//
//  Created by Oliver Hnát on 23.02.2024.
//

import Foundation

struct WordAX {
    struct Word: Identifiable {
        var id: Int
        var name: String
        var description: String
        var shown: Bool
        var nextSpacedRepetitionMilestone: SpacedRepetitionMilestoneEnum?
        var lastSeenOn: Date?
    }
    enum FrequencyEnum: Int {
        case Daily = 1
        case Weekly = 7
        case BiWeekly = 14
        case Monthly = 30
    }
    
    enum SpacedRepetitionMilestoneEnum: Int, CaseIterable {
        case OneDay = 1
        case OneWeek = 7
        case TwoWeeks = 14
        case OneMonth = 30
        case TwoMonths = 60
        case FiveMonths = 150
        case OneYear = 365
        
        static var allCasesSorted: [SpacedRepetitionMilestoneEnum] {
            allCases.sorted {$0.rawValue < $1.rawValue }
        }
        
        func getNext() -> SpacedRepetitionMilestoneEnum? {
            let sorted = WordAX.SpacedRepetitionMilestoneEnum.allCasesSorted
            let milestoneIndex = sorted.firstIndex(where: {$0.rawValue == self.rawValue})!
            if milestoneIndex < WordAX.SpacedRepetitionMilestoneEnum.allCasesSorted.count {
                return sorted[milestoneIndex + 1]
            }
            return nil
        }
    }
    
    struct Settings {
        var frequency: FrequencyEnum = .Daily
        var lastShownNew: Date?
        var dateFormatter: DateFormatter
    }
    
    private mutating func setNextSpacedRepetitionMilestone(word: Word) {
        if word.nextSpacedRepetitionMilestone != nil {
            let current = SpacedRepetitionMilestoneEnum.allCasesSorted.firstIndex(of: word.nextSpacedRepetitionMilestone!) ?? SpacedRepetitionMilestoneEnum.allCases.count
            let index = words.firstIndex(where:{$0.id == word.id}) ?? nil
            if current + 1 < SpacedRepetitionMilestoneEnum.allCases.count && index != nil {
                words[index!].nextSpacedRepetitionMilestone = SpacedRepetitionMilestoneEnum.allCasesSorted[current + 1]
            } else if index != nil {
                words[index!].nextSpacedRepetitionMilestone = nil
            }
        }
    }
    
    var words: [Word] = []
    var settings: Settings
    
    init() {
        self.words = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/mm/YYYY"
        self.settings = Settings(dateFormatter: dateFormatter)
        self.words.append(Word(id: 0, name: "Magnificent", description: "When something is awesome. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", shown: false))
        self.words.append(Word(id: 1, name: "Mesmerising", description: "When something is beautiful", shown: false))
    }
    
}
