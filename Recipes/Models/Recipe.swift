//
//  Item.swift
//  Recipes
//
//  Created by Styles Weiler on 11/14/24.
//

import Foundation
import SwiftData

@Model
final class Recipe {
    var recipeId = UUID()
    var title: String
    var countryOfOrigin: String?
    var author: String?
    var dateCreated: Date
    var prepTime: Int?
    var servings: Int?
    var expertiseRequired: String?
    var caloriesPerServing: Int?
    var isFavorite: Bool
    
    @Relationship(deleteRule: .cascade) var tags: [Tag]
    @Relationship(deleteRule: .cascade) var ingredients: [Ingredient]
    @Relationship(deleteRule: .cascade) var instructions: [Instruction]
    
    init(title: String, countryOfOrigin: String? = nil, author: String? = nil, dateCreated: Date = Date(), prepTime: Int? = nil, servings: Int? = nil, expertiseRequired: String? = nil, caloriesPerServing: Int? = nil, isFavorite: Bool = false) {
        self.title = title
        self.countryOfOrigin = countryOfOrigin
        self.author = author
        self.dateCreated = dateCreated
        self.prepTime = prepTime
        self.servings = servings
        self.expertiseRequired = expertiseRequired
        self.caloriesPerServing = caloriesPerServing
        self.isFavorite = isFavorite
        self.tags = []
        self.ingredients = []
        self.instructions = []
    }
    
}

extension Recipe {
    var asSearchString: String {
        [
            title,
            author ?? "",
            countryOfOrigin ?? "",
            expertiseRequired ?? "",
            ingredients.compactMap { $0.label }.joined(separator: " "),
            tags.map { $0.name }.joined(separator: " ")
        ]
        .joined(separator: " ")
        .lowercased()
    }
}



