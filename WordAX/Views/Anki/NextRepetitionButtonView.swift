//
//  NextRepetitionButtonView.swift
//  WordAX
//
//  Created by Oliver Hnát on 25.02.2024.
//

import SwiftUI
import CoreData

struct NextRepetitionButtonView: View {
    let buttonText: String
    let nextMilestone: Flashcard.SpacedRepetitionMilestoneEnum?
    let flashcardId: UUID
    let color: Color
    let geometry: GeometryProxy
    let timeText: String
    let reload: () -> Void
    @Environment(\.managedObjectContext) var moc
//            { colorScheme == .light ? .cyan : .darkCyan }
    @Binding var showDescription: Bool
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
            Button(action: {
                let request = NSFetchRequest<Flashcard>(entityName: "Flashcard")
                request.predicate = NSPredicate(format: "id == %@", flashcardId as CVarArg)
                do {
                    let result = try moc.fetch(request)
                    let flashcard = result.first
                    flashcard?.lastSeenOn = Date()
                    flashcard?.nextSpacedRepetitionMilestone = nextMilestone?.rawValue ?? 0
                    flashcard?.shownCount += 1
                    try moc.save()
                } catch {
                    print("Something went wrong while saving the flashcard info: \(error.localizedDescription)")
                }
                self.showDescription = false
                reload()
            }) {
                VStack {
                    Text(buttonText)
                    Text(timeText)
                        .font(.footnote)
                        .bold()
                }
                .padding(.vertical, geometry.size.height / 80)
                .foregroundColor(.black)
                .frame(maxWidth: geometry.size.width)
            }
            .background(color)
            .buttonStyle(.plain)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension ShapeStyle where Self == Color {
    // color darker version of cyan from hex palette
    public static var darkCyan: Color {
        Color(red: 34/255, green: 121/255, blue: 161/255)
    }
}

//#Preview {
//    @State var showDescription = false
//    let flashcard = try? DataController.preview.viewContext.fetch(Flashcard.fetchRequest()).first
//    return NextRepetitionButtonView(buttonText: "Excellent", nextMilestone: Flashcard.SpacedRepetitionMilestoneEnum.OneDay, showDescription: $showDescription)
//        .environment(\.managedObjectContext, DataController.preview.container.viewContext)
//}
