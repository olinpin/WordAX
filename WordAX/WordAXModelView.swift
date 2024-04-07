//
//  WordAXModelView.swift
//  WordAX
//
//  Created by Oliver Hnát on 23.02.2024.
//

import Foundation

class WordAXModelView: ObservableObject {
    @Published private var model: WordAX
    typealias FlashCard = WordAX.FlashCard
    init() {
        model = WordAX()
    }
    
    public var flashcards: [FlashCard] {
        model.flashcards
    }
    
    public func getDateFormatter() -> DateFormatter {
        model.settings.dateFormatter
    }
    
    public func getFlashCardsToDisplay() -> FlashCard? {
        let flashcards = model.flashcards
        
        if flashcards.count > 0 {
            let notShownFlashCards = flashcards.filter({!$0.shown})
            if notShownFlashCards.count == 0 {
                return nil
            }
            // if today is the date they're supposed to be shown
            
            let displayToday = flashcards.filter({ $0.lastSeenOn != nil && $0.lastSeenOn!.addSpacedRepetitionMilestone(milestone: $0.nextSpacedRepetitionMilestone).isBeforeTodayOrToday()})
            if  displayToday.count > 0 {
                return displayToday.first!
            }
            
//            let shownWords = words.filter({ $0.shown })
//            if shownWords.count == 0 {
            return notShownFlashCards.sorted(by: {$0.id < $1.id}).first
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
    
    public func ankiButtonClicked(flashcardId: Int, milestone: WordAX.SpacedRepetitionMilestoneEnum?) {
        model.setSpacedRepetitionMilestone(flashcardId: flashcardId, milestone: milestone)
        model.flashcardShown(flashcardId: flashcardId)
    }
    
    public func addFlashCard(name: String, description: String) {
        self.model.add(flashcard: FlashCard(id: (self.flashcards.map{$0.id}.max() ?? -1) + 1, name: name, description: description))
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
    
    func addSpacedRepetitionMilestone(milestone: WordAX.SpacedRepetitionMilestoneEnum?) -> Date {
        if milestone == nil {
            return self
        }
        return self.addingTimeInterval(TimeInterval(milestone!.rawValue * 24 * 60 * 60))
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
