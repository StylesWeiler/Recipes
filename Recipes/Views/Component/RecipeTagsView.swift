//
//  RecipeTagsView.swift
//  Recipes
//
//  Created by Styles Weiler on 12/11/24.
//


import SwiftUI
import SwiftData

struct RecipeTagsView: View {
    @Environment(RecipeViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    let recipe: Recipe
    
    @State private var showingTagManagement = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.tags) { tag in
                    Button(action: {
                        if recipe.tags.contains(where: { $0.tagId == tag.tagId }) {
                            viewModel.removeTag(tag, from: recipe)
                        } else {
                            viewModel.addTag(tag, to: recipe)
                        }
                    }) {
                        HStack {
                            Text(tag.name)
                            Spacer()
                            if recipe.tags.contains(where: { $0.tagId == tag.tagId }) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
            .navigationTitle("Categories")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingTagManagement = true }) {
                        Label("Manage Categories", systemImage: "tag")
                    }
                }
            }
            .sheet(isPresented: $showingTagManagement) {
                TagManagementView()
            }
        }
    }
}


