//
//  AddEditRecipeView.swift
//  Recipes
//
//  Created by Styles Weiler on 12/9/24.
//


// I based my AddEditRecipeView off of the one Dr.Liddle did

import Foundation
import SwiftUI

struct AddEditRecipeView: View {
    @Environment(RecipeViewModel.self) private var viewModel
    @Environment(\.dismiss) var dismiss
    
    let editRecipe: Recipe?
    
    @State private var title = ""
    @State private var countryOfOrigin: String?
    @State private var author: String?
    @State private var prepTime: Int?
    @State private var servings: Int?
    @State private var expertiseRequired: String?
    @State private var caloriesPerServing: Int?
    @State private var isFavorite = false
    @State private var ingredients: [Ingredient] = []
    @State private var instructions: [Instruction] = []
    @State private var showingFlagSelector = false
    
    init(editRecipe: Recipe? = nil) {
        self.editRecipe = editRecipe
        
        if let recipe = editRecipe {
            _title = State(initialValue: recipe.title)
            _countryOfOrigin = State(initialValue: recipe.countryOfOrigin)
            _author = State(initialValue: recipe.author)
            _prepTime = State(initialValue: recipe.prepTime)
            _servings = State(initialValue: recipe.servings)
            _expertiseRequired = State(initialValue: recipe.expertiseRequired)
            _caloriesPerServing = State(initialValue: recipe.caloriesPerServing)
            _isFavorite = State(initialValue: recipe.isFavorite)
            _ingredients = State(initialValue: recipe.ingredients)
            _instructions = State(initialValue: recipe.instructions)
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                RecipeDetailsSection(
                    title: $title,
                    countryOfOrigin: $countryOfOrigin,
                    author: $author,
                    prepTime: $prepTime,
                    servings: $servings,
                    expertiseRequired: $expertiseRequired,
                    caloriesPerServing: $caloriesPerServing,
                    isFavorite: $isFavorite,
                    showingFlagSelector: $showingFlagSelector
                )
                
                IngredientsSection(ingredients: $ingredients)
                
                InstructionsSection(instructions: $instructions)
            }
            .navigationTitle("\(isEditing ? "Edit" : "Add") Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button(action: saveRecipe) {
                    Text("Save")
                        .fontWeight(.bold)
                }
                .disabled(title.isEmpty)
            )
        }
        .sheet(isPresented: $showingFlagSelector) {
            FlagSelectorView(selectedFlag: Binding(
                get: { countryOfOrigin ?? "" },
                set: { countryOfOrigin = $0.isEmpty ? nil : $0 }
            ))
        }
    }
    
    private var isEditing: Bool {
        editRecipe != nil
    }
    
    private func saveRecipe() {
        if let recipe = editRecipe {
            // Update existing recipe
            recipe.title = title
            recipe.countryOfOrigin = countryOfOrigin
            recipe.author = author
            recipe.prepTime = prepTime
            recipe.servings = servings
            recipe.expertiseRequired = expertiseRequired
            recipe.caloriesPerServing = caloriesPerServing
            recipe.isFavorite = isFavorite
            recipe.ingredients = ingredients
            recipe.instructions = instructions
            viewModel.updateRecipe(recipe)
        } else {
            // Create new recipe
            let recipe = viewModel.createRecipe(
                title: title,
                countryOfOrigin: countryOfOrigin ?? "",
                author: author ?? "",
                prepTime: prepTime ?? 0,
                servings: servings ?? 0,
                expertiseRequired: expertiseRequired ?? "",
                caloriesPerServing: caloriesPerServing ?? 0
            )
            recipe.isFavorite = isFavorite
            recipe.ingredients = ingredients
            recipe.instructions = instructions
        }
        dismiss()
    }
}
