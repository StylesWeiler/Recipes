//
//  Instruction.swift
//  Recipes
//
//  Created by Styles Weiler on 12/2/24.
//

import Foundation
import SwiftData

@Model
final class Instruction {
    var instructionId = UUID()
    var order: Int
    var content: String
    
    @Relationship(inverse: \Recipe.instructions) var recipe: Recipe?
    
    init(order: Int, content: String) {
        self.order = order
        self.content = content
    }
    
    func editInstruction(instruction: Instruction) {
        self.order = instruction.order
        self.content = instruction.content
    }
    
    func deleteInstruction() {
        if let recipe = recipe {
            recipe.instructions.removeAll { $0.instructionId == self.instructionId }
        }
        if let modelContext = self.modelContext {
            modelContext.delete(self)
        }
    }
}
