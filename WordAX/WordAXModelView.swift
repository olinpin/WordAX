//
//  WordAXModelView.swift
//  WordAX
//
//  Created by Oliver Hnát on 23.02.2024.
//

import Foundation

class WordAXModelView: ObservableObject {
    @Published private var model: WordAX
    typealias Word = WordAX.Word
    init() {
        model = WordAX()
    }
    
    public func getDateFormatter() -> DateFormatter {
        model.settings.dateFormatter
    }
    
    public func getWordToDisplay() -> Word? {
        let words = model.words
        
        if words.count > 0 {
            let notShownWords = words.filter({!$0.shown})
            if notShownWords.count == 0 {
                return nil
            }
            // if today is the date they're supposed to be shown
            let displayToday = words.filter({ $0.lastSeenOn != nil && $0.lastSeenOn!.addSpacedRepetitionMilestone(milestone: $0.nextSpacedRepetitionMilestone!).isBeforeTodayOrToday()})
            if  displayToday.count > 0 {
                return displayToday.first!
            }
            
            // first word ever shown
//            let shownWords = words.filter({ $0.shown })
//            if shownWords.count == 0 {
            return notShownWords.sorted(by: {$0.id < $1.id}).first
//            }
            // if today is the day to show a new word
//            let settings = model.settings
//            if shownWords.count == 0 ||
//                settings.lastShownNew == nil ||
//                settings.lastShownNew!.addFrequency(frequency: settings.frequency).isAfterToday() {
//                return words.first!
//            }
        }
        // otherwise show nothing
        return nil
    }
    
    public func ankiButtonClicked(wordId: Int, milestone: WordAX.SpacedRepetitionMilestoneEnum?) {
        model.setSpacedRepetitionMilestone(wordId: wordId, milestone: milestone)
        model.wordShown(wordId: wordId)
    }
}


extension Date {
    private func getOnlyDate(date: Date) -> DateComponents {
        Calendar.current.dateComponents([.day, .month, .year], from: date)
    }
    func isSameAs(_ date: Date) -> Bool {
        let selfDate = getOnlyDate(date: self)
        let paramDate = getOnlyDate(date: date)
        return selfDate.day == paramDate.day && selfDate.month == paramDate.month && selfDate.year == paramDate.year
    }
    
    func isToday() -> Bool {
        self.isSameAs(Date())
    }
    
    func isAfter(_ date: Date) -> Bool {
        let selfDate = getOnlyDate(date: self)
        let paramDate = getOnlyDate(date: date)
        return selfDate.year! > paramDate.year! || selfDate.month! > paramDate.month! || selfDate.day! > paramDate.day!
    }
    
    func isBefore(_ date: Date) -> Bool {
        let selfDate = getOnlyDate(date: self)
        let paramDate = getOnlyDate(date: date)
        return selfDate.year! < paramDate.year! || selfDate.month! < paramDate.month! || selfDate.day! < paramDate.day!
    }
    
    func addFrequency(frequency: WordAX.FrequencyEnum) -> Date {
        self.addingTimeInterval(TimeInterval(frequency.rawValue * 24 * 60 * 60))
    }
    
    func addSpacedRepetitionMilestone(milestone: WordAX.SpacedRepetitionMilestoneEnum) -> Date {
        self.addingTimeInterval(TimeInterval(milestone.rawValue * 24 * 60 * 60))
    }
    
    func isAfterToday() -> Bool {
        self.isAfter(Date())
    }
    
    func isBeforeToday() -> Bool {
        self.isBefore(Date())
    }
    
    func isBeforeTodayOrToday() -> Bool {
        self.isBeforeToday() || self.isToday()
    }
}
