//
//  SettingsView.swift
//  WordAX
//
//  Created by Oliver Hnát on 23.02.2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct SettingsView: View {
    @State var isImporting: Bool = false
    var body: some View {
        Group {
            //        List {
            Button(action: {
                // open file explorer
                isImporting.toggle()
            }, label: {
                Text("CLICK ME PLSSS")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.yellow)
                    .clipShape(.buttonBorder)
            })
        }
        .fileImporter(isPresented: $isImporting, allowedContentTypes: [.apkg]) { result in
            switch result {
            case .success(let text):
                print(text)
            case .failure(let error):
                print(error)
            }

        }
//        }
    }
}

extension UTType {
    public static let apkg: UTType = UTType(exportedAs: "com.wordax.apkg")
}

#Preview {
    SettingsView()
        .environmentObject(WordAXModelView())
        .environment(\.managedObjectContext, DataController.preview.container.viewContext)
}
