//
//  NextRepetitionButtonView.swift
//  WordAX
//
//  Created by Oliver Hnát on 25.02.2024.
//

import SwiftUI

struct NextRepetitionButtonView: View {
    let buttonText: String
    let nextMilestone: WordAX.SpacedRepetitionMilestoneEnum?
    let wordId: Int
    let width: CGFloat
    let color: Color
    let geometry: GeometryProxy
    let timeText: String
//            { colorScheme == .light ? .cyan : .darkCyan }
    @Binding var showDescription: Bool
    @EnvironmentObject var model: WordAXModelView
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
            Button(action: {
                model.ankiButtonClicked(wordId: wordId, milestone: nextMilestone)
                self.showDescription = false
            }) {
                VStack {
                    Text(buttonText)
                    Text(">" + timeText)
                        .font(.footnote)
                        .bold()
                }
                .padding(.vertical, geometry.size.height / 80)
                .foregroundColor(colorScheme == .light ? .black : .white)
                .frame(maxWidth: width)
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
//    return NextRepetitionButtonView(buttonText: "Excellent", nextMilestone: WordAX.SpacedRepetitionMilestoneEnum.OneDay, wordId: 0, showDescription: $showDescription)
//        .environmentObject(WordAXModelView())
//}
