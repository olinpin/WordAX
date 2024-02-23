//
//  AnkiView.swift
//  WordAX
//
//  Created by Oliver Hnát on 23.02.2024.
//

import SwiftUI

struct AnkiView: View {
    @EnvironmentObject var model: WordAXModelView
    var body: some View {
        Text("This is Anki View")
    }
}

#Preview {
    AnkiView()
        .environmentObject(WordAXModelView())
}
