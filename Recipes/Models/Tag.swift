//
//  Tag.swift
//  Recipes
//
//  Created by Styles Weiler on 12/2/24.
//


import Foundation
import SwiftData

@Model
final class Tag {
    var tagId = UUID()
    var name: String
    var dateCreated: Date
    
    @Relationship var recipes: [Recipe]
    
    init(name: String, dateCreated: Date) {
        self.name = name
        self.dateCreated = dateCreated
        
        // Initialize relationship as empty array
        self.recipes = []
    }
    
    static let defaultTags = [
        "Favorites",
        "Italian Dishes",
        "American Classics",
        "Desserts",
        "Breakfast",
        "Gluten-Free"
    ]
}
