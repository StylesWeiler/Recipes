//
//  SampleRecipes.swift
//  Recipes
//
//  Created by Styles Weiler on 12/3/24.
//

import Foundation

private func createDefaultRecipes() -> [Recipe] {
    [
        Recipe(
            title: "Classic Chocolate Chip Cookies",
            countryOfOrigin: "America",
            author: "Sarah Baker",
            dateCreated: Date(),
            prepTime: 45,
            servings: 24,
            expertiseRequired: "Beginner",
            caloriesPerServing: 150,
            isFavorite: false
        ),
        Recipe(
            title: "Authentic Spaghetti Carbonara",
            countryOfOrigin: "Italy",
            author: "Marco Rossi",
            dateCreated: Date(),
            prepTime: 30,
            servings: 4,
            expertiseRequired: "Intermediate",
            caloriesPerServing: 380,
            isFavorite: false
        ),
        Recipe(
            title: "Classic French Toast",
            countryOfOrigin: "France",
            author: "Pierre Dubois",
            dateCreated: Date(),
            prepTime: 20,
            servings: 4,
            expertiseRequired: "Beginner",
            caloriesPerServing: 250,
            isFavorite: false
        ),
        Recipe(
            title: "Fish Amok",
            countryOfOrigin: "Cambodia",
            author: "Sokha Chhum",
            dateCreated: Date(),
            prepTime: 60,
            servings: 6,
            expertiseRequired: "Advanced",
            caloriesPerServing: 320,
            isFavorite: false
        ),
        Recipe(
            title: "Gluten-Free Banana Bread",
            countryOfOrigin: "America",
            author: "Emma Wells",
            dateCreated: Date(),
            prepTime: 65,
            servings: 12,
            expertiseRequired: "Intermediate",
            caloriesPerServing: 180,
            isFavorite: false
        ),
        Recipe(
            title: "Traditional Tiramisu",
            countryOfOrigin: "Italy",
            author: "Sofia Conti",
            dateCreated: Date(),
            prepTime: 40,
            servings: 8,
            expertiseRequired: "Advanced",
            caloriesPerServing: 420,
            isFavorite: false
        )
    ]
}

private func createDefaultIngredients(for recipe: Recipe) -> [Ingredient] {
    switch recipe.title {
    case "Classic Chocolate Chip Cookies":
        return [
            Ingredient(quantity: "2 1/4 cups", label: "all-purpose flour"),
            Ingredient(quantity: "1 cup", label: "butter, softened"),
            Ingredient(quantity: "3/4 cup", label: "granulated sugar"),
            Ingredient(quantity: "3/4 cup", label: "brown sugar"),
            Ingredient(quantity: "2", label: "large eggs"),
            Ingredient(quantity: "2 cups", label: "chocolate chips")
        ]
    case "Authentic Spaghetti Carbonara":
        return [
            Ingredient(quantity: "1 pound", label: "spaghetti"),
            Ingredient(quantity: "4 ounces", label: "guanciale"),
            Ingredient(quantity: "4", label: "large eggs"),
            Ingredient(quantity: "1 cup", label: "Pecorino Romano"),
            Ingredient(quantity: "1 cup", label: "Parmigiano-Reggiano")
        ]
    case "Fish Amok":
        return [
            Ingredient(quantity: "1 pound", label: "white fish fillets"),
            Ingredient(quantity: "2 tablespoons", label: "red curry paste"),
            Ingredient(quantity: "1 cup", label: "coconut milk"),
            Ingredient(quantity: "2", label: "kaffir lime leaves"),
            Ingredient(quantity: "1 tablespoon", label: "fish sauce")
        ]
    default:
        return []
    }
}

private func createDefaultInstructions(for recipe: Recipe) -> [Instruction] {
    switch recipe.title {
    case "Classic Chocolate Chip Cookies":
        return [
            Instruction(order: 1, content: "Preheat oven to 375°F"),
            Instruction(order: 2, content: "Cream together butter and sugars"),
            Instruction(order: 3, content: "Beat in eggs one at a time"),
            Instruction(order: 4, content: "Mix in dry ingredients"),
            Instruction(order: 5, content: "Stir in chocolate chips"),
            Instruction(order: 6, content: "Drop spoonfuls onto baking sheets"),
            Instruction(order: 7, content: "Bake for 10-12 minutes")
        ]
    case "Authentic Spaghetti Carbonara":
        return [
            Instruction(order: 1, content: "Bring large pot of salted water to boil"),
            Instruction(order: 2, content: "Cook spaghetti al dente"),
            Instruction(order: 3, content: "Crisp guanciale in pan"),
            Instruction(order: 4, content: "Mix eggs and cheese"),
            Instruction(order: 5, content: "Toss hot pasta with egg mixture"),
            Instruction(order: 6, content: "Add pasta water as needed")
        ]
    default:
        return []
    }
}
