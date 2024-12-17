//
//  InstructionsSection.swift
//  Recipes
//
//  Created by Styles Weiler on 12/9/24.
//


import Foundation
import SwiftUI

struct InstructionsSection: View {
    @Binding var instructions: [Instruction]
    
    var body: some View {
        Section(header: Text("Instructions")) {
            ForEach($instructions.indices, id: \.self) { index in
                VStack(alignment: .leading) {
                    Text("Step \(index + 1)")
                    TextEditor(text: $instructions[index].content)
                        .frame(height: 60)
                }
            }
            .onDelete { indexSet in
                instructions.remove(atOffsets: indexSet)
            }
            Button("Add Step") {
                instructions.append(Instruction(order: instructions.count + 1, content: ""))
            }
        }
    }
}
