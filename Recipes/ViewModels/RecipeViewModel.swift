//
//  RecipeViewModel.swift
//  Recipes
//
//  Created by Styles Weiler on 12/2/24.
//

import Foundation
import SwiftData

@Observable
class RecipeViewModel {
    private var modelContext: ModelContext
    
    // MARK: - Properties
    private(set) var recipes: [Recipe] = []
    private(set) var favoriteRecipes: [Recipe] = []
    private(set) var tags: [Tag] = []
    
    // MARK: - Initialization
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchData()
    }
    
    // MARK: - Data Fetching
    func fetchData() {
        print("Fetching data...")
        try? modelContext.save()
        fetchRecipes()
        fetchFavorites()
        fetchOrCreateDefaultTags()
    }
    
    private func fetchRecipes() {
        let descriptor = FetchDescriptor<Recipe>(sortBy: [SortDescriptor(\.title)])
        do {
            recipes = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch recipes: \(error)")
        }
    }
    
    private func fetchFavorites() {
        let descriptor = FetchDescriptor<Recipe>(
            predicate: #Predicate<Recipe> { $0.isFavorite },
            sortBy: [SortDescriptor(\.title)]
        )
        do {
            favoriteRecipes = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch favorites: \(error)")
        }
    }
    
    func fetchOrCreateDefaultTags() {
        let descriptor = FetchDescriptor<Tag>(sortBy: [SortDescriptor(\.name)])
        do {
            tags = try modelContext.fetch(descriptor)
            print("Fetched \(tags.count) tags")
        } catch {
            print("Failed to fetch tags: \(error)")
        }
    }
    
    // MARK: - Recipe Operations
    func createRecipe(title: String, countryOfOrigin: String, author: String, prepTime: Int,
                     servings: Int, expertiseRequired: String, caloriesPerServing: Int) -> Recipe {
        let recipe = Recipe(
            title: title,
            countryOfOrigin: countryOfOrigin,
            author: author,
            dateCreated: Date(),
            prepTime: prepTime,
            servings: servings,
            expertiseRequired: expertiseRequired,
            caloriesPerServing: caloriesPerServing,
            isFavorite: false
        )
        modelContext.insert(recipe)
        saveChanges()
        fetchData()
        return recipe
    }
    
    func updateRecipe(_ recipe: Recipe) {
        saveChanges()
        fetchData()
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        modelContext.delete(recipe)
        saveChanges()
        fetchData()
    }
    
    func toggleFavorite(_ recipe: Recipe) {
        recipe.isFavorite.toggle()
        saveChanges()
        fetchData()
    }
    
    // MARK: - Ingredient Operations
    func addIngredient(to recipe: Recipe, quantity: String, label: String) {
        let ingredient = Ingredient(quantity: quantity, label: label)
        ingredient.recipe = recipe
        recipe.ingredients.append(ingredient)
        saveChanges()
    }
    
    func updateIngredient(_ ingredient: Ingredient, quantity: String, label: String) {
        ingredient.quantity = quantity
        ingredient.label = label
        saveChanges()
    }
    
    func deleteIngredient(_ ingredient: Ingredient) {
        if let recipe = ingredient.recipe {
            recipe.ingredients.removeAll { $0.ingredientId == ingredient.ingredientId }
        }
        modelContext.delete(ingredient)
        saveChanges()
    }
    
    // MARK: - Instruction Operations
    func addInstruction(to recipe: Recipe, content: String) {
        let order = recipe.instructions.count + 1
        let instruction = Instruction(order: order, content: content)
        instruction.recipe = recipe
        recipe.instructions.append(instruction)
        saveChanges()
    }
    
    func updateInstruction(_ instruction: Instruction, content: String) {
        instruction.content = content
        saveChanges()
    }
    
    func deleteInstruction(_ instruction: Instruction) {
        if let recipe = instruction.recipe {
            recipe.instructions.removeAll { $0.instructionId == instruction.instructionId }
            // Reorder remaining instructions
            recipe.instructions.enumerated().forEach { index, instruction in
                instruction.order = index + 1
            }
        }
        modelContext.delete(instruction)
        saveChanges()
    }
    
    // MARK: - Tag Operations
    func createTag(name: String) -> Tag {
        let tag = Tag(name: name, dateCreated: Date())
        modelContext.insert(tag)
        saveChanges()
        fetchOrCreateDefaultTags()
        return tag
    }
    
    func deleteTag(_ tag: Tag) {
        // Remove the tag from all recipes
        tag.recipes.forEach { recipe in
            recipe.tags.removeAll { $0.tagId == tag.tagId }
        }
        modelContext.delete(tag)
        saveChanges()
        fetchOrCreateDefaultTags()
    }

    func addTag(_ tag: Tag, to recipe: Recipe) {
        if !recipe.tags.contains(where: { $0.tagId == tag.tagId }) {
            recipe.tags.append(tag)
            tag.recipes.append(recipe)
        }
        saveChanges()
    }

    func removeTag(_ tag: Tag, from recipe: Recipe) {
        recipe.tags.removeAll { $0.tagId == tag.tagId }
        tag.recipes.removeAll { $0.recipeId == recipe.recipeId }
        saveChanges()
    }
    
    // MARK: - Filtering
    // This was inspired by Prof Liddle's implementation
    func filterRecipesBySearchAndCategory(searchText: String, tag: Tag?) -> [Recipe] {
        let searchResults = if searchText.isEmpty {
            recipes
        } else {
            recipes.filter { recipe in
                recipe.asSearchString.contains(searchText.lowercased())
            }
        }
        
        // If no tag selected or if searching for favorites
        guard let tag = tag else { return searchResults }
        if tag.name == "Favorites" {
            return searchResults.filter { $0.isFavorite }
        }
        
        // Filter by selected tag
        return searchResults.filter { recipe in
            recipe.tags.contains(tag)
        }
    }
    
    func recipesForTag(_ tag: Tag) -> [Recipe] {
        return tag.recipes.sorted { $0.title < $1.title }
    }
    
    // MARK: - Utilities
    private func saveChanges() {
        try? modelContext.save()
    }
}
