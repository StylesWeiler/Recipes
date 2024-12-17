//
//  Ingredient.swift
//  Recipes
//
//  Created by Styles Weiler on 12/2/24.
//

import Foundation
import SwiftData

@Model
final class Ingredient {
    
    var ingredientId = UUID()
    var quantity: String
    var label: String?
    
    @Relationship(inverse: \Recipe.ingredients) var recipe: Recipe?
    
    init(quantity: String, label: String?) {
        self.quantity = quantity
        self.label = label
    }
}
