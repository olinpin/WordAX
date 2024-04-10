//
//  WordAXModelView.swift
//  WordAX
//
//  Created by Oliver Hnát on 23.02.2024.
//

import Foundation
import SwiftUI

class WordAXModelView: ObservableObject {
    typealias SpacedRepetitionMilestoneEnum = Flashcard.SpacedRepetitionMilestoneEnum
    
    let settings: Settings
    
    init() {
        let hourString = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: NSLocale.current)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY \(hourString?.contains("a") ?? true ? "hh" : "HH"):mm\(hourString?.contains("a") ?? true ? " a" : "")"
        self.settings = Settings(dateFormatter: dateFormatter)
    }
    
    struct Settings {
        var dateFormatter: DateFormatter
    }

    public func getFlashcards(moc: DataController) -> [Flashcard] {
        moc.getAllFlashcards()
    }
    
    public func getDateFormatter() -> DateFormatter {
        self.settings.dateFormatter
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
    
//    func addFrequency(frequency: WordAX.FrequencyEnum) -> Date {
//        self.addingTimeInterval(TimeInterval(frequency.rawValue * 24 * 60 * 60))
//    }
    
    func addSpacedRepetitionMilestone(milestone: Flashcard.SpacedRepetitionMilestoneEnum?) -> Date {
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
