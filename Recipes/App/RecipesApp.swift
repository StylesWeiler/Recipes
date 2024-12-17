//
//  RecipesApp.swift
//  Recipes
//
//  Created by Styles Weiler on 11/14/24.
//

import SwiftUI
import SwiftData

@main
struct RecipeApp: App {
    let container: ModelContainer
    let viewModel: RecipeViewModel
    
    init() {
        do {
            // Configure schema and container
            let schema = Schema([Recipe.self, Tag.self, Ingredient.self, Instruction.self])
            
            // Create a fresh configuration
            let config = ModelConfiguration(
                "RecipeDatabase",
                schema: schema,
                isStoredInMemoryOnly: false
            )
            
            // Create new container
            container = try ModelContainer(for: schema, configurations: config)
            let context = container.mainContext
            
            // Initialize ViewModel with container's context
            viewModel = RecipeViewModel(modelContext: context)
            
            // Check if we need to create default data
            let descriptor = FetchDescriptor<Recipe>()
            if (try? context.fetch(descriptor))?.isEmpty ?? true {
                print("Initializing default data...")
                
                // Initialize default tags first
                Tag.defaultTags.forEach { tagName in
                    let tag = Tag(name: tagName, dateCreated: Date())
                    context.insert(tag)
                }
                
                try? context.save()
                
                // Initialize recipes and their relationships
                let recipeCatalog = RecipeCatalog(modelContext: context)
                recipeCatalog.importDefaultRecipes()
                
                try? context.save()
                print("Default data initialized.")
            }
            
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RecipeOverviewView(viewModel: viewModel)
        }
        .modelContainer(container)
        .environment(viewModel)
    }
}
