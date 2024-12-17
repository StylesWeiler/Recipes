//
//  FlagSelectorView.swift
//  Recipes
//
//  Created by Styles Weiler on 12/2/24.
//

import Foundation
import SwiftUI
import SwiftData

struct FlagSelectorView: View {
    @Binding var selectedFlag: String
    @Environment(\.dismiss) private var dismiss
    
    // Add country flags to Assets folder with same name
    let availableFlags = ["Italy", "Brazil", "Cambodia", "America", "France"]
    
    var body: some View {
        NavigationView {
            List(availableFlags, id: \.self) { flag in
                Button(action: {
                    selectedFlag = flag
                    dismiss()
                }) {
                    HStack {
                        Image(flag)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 20)
                        Text(flag.capitalized)
                        Spacer()
                        if selectedFlag == flag {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Select Country")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
