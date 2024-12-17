//
//  RecipeOverviewView.swift
//  Recipes
//
//  Created by Styles Weiler on 12/2/24.
//


import Foundation
import SwiftUI
import SwiftData


// This Overview page was inspired by Prof Liddle's Catalog page

struct RecipeOverviewView: View {
    @State private var searchString = ""
    @State private var selectedTag: Tag?
    @State private var showingAddRecipe = false
    @State private var selectedRecipe: Recipe?
    @State private var showingSidebar = false
    @State private var columnVisibility: NavigationSplitViewVisibility = .automatic
    @State private var showingTagManagement = false
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    let viewModel: RecipeViewModel
    
    init(viewModel: RecipeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            if horizontalSizeClass == .compact {
                // iPhone Layout
                NavigationStack {
                    List {
                        ForEach(filteredRecipes) { recipe in
                            NavigationLink {
                                RecipeDetailView(recipe: recipe)
                            } label: {
                                RecipeListItem(recipe: recipe)
                            }
                        }
                    }
                    .navigationTitle(selectedTag?.name ?? "All Recipes")
                    .searchable(text: $searchString)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Menu {
                                Button(action: { selectedTag = nil }) {
                                    HStack {
                                        Text("All Recipes")
                                        if selectedTag == nil {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                                
                                ForEach(viewModel.tags, id: \.tagId) { tag in
                                    Button(action: {
                                        selectedTag = (selectedTag == tag) ? nil : tag
                                    }) {
                                        HStack {
                                            Text(tag.name)
                                            if selectedTag == tag {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                                
                                Divider()
                                
                                Button(action: { showingTagManagement = true }) {
                                    Label("Manage Categories", systemImage: "tag")
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "line.3.horizontal.decrease.circle")
                                    Text(selectedTag?.name ?? "All Recipes")
                                }
                            }
                        }
                        
                        ToolbarItem(placement: .primaryAction) {
                            Button(action: { showingAddRecipe = true }) {
                                Label("Add Recipe", systemImage: "plus")
                            }
                        }
                    }
                    .sheet(isPresented: $showingAddRecipe) {
                        AddEditRecipeView()
                    }
                    .sheet(isPresented: $showingTagManagement) {
                        TagManagementView()
                    }
                }
            } else {
                // iPad Layout
                NavigationSplitView(columnVisibility: $columnVisibility) {
                    List(selection: $selectedTag) {
                        NavigationLink(value: Optional<Tag>.none) {
                            Text("All Recipes")
                        }
                        
                        ForEach(viewModel.tags, id: \.tagId) { tag in
                            NavigationLink(value: Optional(tag)) {
                                Text(tag.name)
                            }
                        }
                    }
                    .navigationTitle("Categories")
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button(action: { showingTagManagement = true }) {
                                Label("Manage Categories", systemImage: "tag")
                            }
                        }
                    }
                    .sheet(isPresented: $showingTagManagement) {
                        TagManagementView()
                    }
                } content: {
                    List {
                        ForEach(filteredRecipes) { recipe in
                            RecipeListItem(recipe: recipe)
                                .onTapGesture {
                                    selectedRecipe = recipe
                                }
                        }
                    }
                    .navigationTitle(selectedTag?.name ?? "All Recipes")
                    .searchable(text: $searchString)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button(action: { showingAddRecipe = true }) {
                                Label("Add Recipe", systemImage: "plus")
                            }
                        }
                    }
                    .sheet(isPresented: $showingAddRecipe) {
                        AddEditRecipeView()
                    }
                } detail: {
                    if let recipe = selectedRecipe {
                        RecipeDetailView(recipe: recipe)
                    } else {
                        Text("Select a recipe")
                    }
                }
            }
        }
    }
    
    var filteredRecipes: [Recipe] {
        viewModel.filterRecipesBySearchAndCategory(
            searchText: searchString,
            tag: selectedTag
        )
    }
}
