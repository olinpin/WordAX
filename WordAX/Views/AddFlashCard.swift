//
//  addFlashCard.swift
//  WordAX
//
//  Created by Oliver Hnát on 07.04.2024.
//

import SwiftUI

struct AddFlashCard: View {
    @State var text: String = ""
    @State var description: String = ""
    @Binding var isShowing: Bool
    var addFlashCard: (String, String) -> Void
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Flashcard details") ) {
                    TextField("Name", text: $text)
                    TextField("Description", text: $description, axis: .vertical)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button(action: {
                        self.isShowing = false
                    }, label: {
                        Text("Cancel")
                            .foregroundStyle(.red)
                    })
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        self.addFlashCard(self.text, self.description)
                        self.isShowing = false
                    }, label: {
                        Text("Create")
                            .bold()
                    })
                }
            }
            .navigationTitle("Add Flashcard")
        }
    }
}

#Preview {
    @State var isShowing = true
    func add(name: String, desc: String) {
        return
    }
    return AddFlashCard(isShowing: $isShowing, addFlashCard: add)
}
