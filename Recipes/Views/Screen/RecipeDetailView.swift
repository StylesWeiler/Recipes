//
//  RecipeDetailView.swift
//  Recipes
//
//  Created by Styles Weiler on 12/2/24.
//

import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    @Environment(RecipeViewModel.self) private var viewModel
    var recipe: Recipe // @Bindable?
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.dismiss) private var dismiss
    
    @State private var isEditing = false
    @State private var showingTagsSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Text(recipe.title)
                        .font(.title)
                        .bold()
                    Spacer()
                    if let origin = recipe.countryOfOrigin, !origin.isEmpty {
                        Image(origin)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 30)
                    }
                }
                
                // Tags Info
                ScrollView(.horizontal, showsIndicators: false) {
                     HStack {
                         ForEach(recipe.tags) { tag in
                             Text(tag.name)
                                 .padding(.horizontal, 10)
                                 .padding(.vertical, 5)
                                 .background(Color.accentColor.opacity(0.1))
                                 .clipShape(RoundedRectangle(cornerRadius: 8))
                         }
                         
                         Button(action: { showingTagsSheet = true }) {
                             Image(systemName: "plus.circle.fill")
                                 .foregroundStyle(.secondary)
                         }
                     }
                 }
                
                // Recipe Info
                VStack(alignment: .leading, spacing: 10) {
                    Text("Author: \(recipe.author ?? "Unknown")")
                    Text("Origin: \(recipe.countryOfOrigin ?? "Unknown")")
                    Text("Prep Time: \(recipe.prepTime ?? 0) mins")
                    Text("Servings: \(recipe.servings ?? 0)")
                    Text("Expertise Required: \(recipe.expertiseRequired ?? "Unknown")")
                    Text("Calories per Serving: \(recipe.caloriesPerServing ?? 0)")
                }
                .foregroundStyle(.secondary)
                
                // Ingredients
                VStack(alignment: .leading, spacing: 10) {
                    Text("Ingredients")
                        .font(.title2)
                        .bold()
                    ForEach(recipe.ingredients, id: \.ingredientId) { ingredient in
                        Text("\(ingredient.quantity) \(ingredient.label ?? "")")
                    }
                }
                
                // Instructions
                VStack(alignment: .leading, spacing: 10) {
                    Text("Directions")
                        .font(.title2)
                        .bold()
                    ForEach(recipe.instructions.sorted(by: { $0.order < $1.order }), id: \.instructionId) { instruction in
                        Text("\(instruction.order). \(instruction.content)")
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {
                        isEditing = true
                    }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(action: { showingTagsSheet = true }) {
                        Label("Manage Categories", systemImage: "tag")
                    }
                    
                    Button(role: .destructive, action: {
                        viewModel.deleteRecipe(recipe)
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            AddEditRecipeView(editRecipe: recipe)
        }
        .sheet(isPresented: $showingTagsSheet) {
             RecipeTagsView(recipe: recipe)
         }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Recipe.self, configurations: config)
    
    let sampleRecipe = Recipe(
        title: "Sample Recipe",
        countryOfOrigin: "Cambodia",
        author: "Preview Author",
        dateCreated: Date(),
        prepTime: 30,
        servings: 4,
        expertiseRequired: "Beginner",
        caloriesPerServing: 300,
        isFavorite: false
    )
    
    return RecipeDetailView(recipe: sampleRecipe)
        .modelContainer(container)
}




