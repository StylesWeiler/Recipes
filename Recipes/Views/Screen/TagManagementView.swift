//
//  TagManagementView.swift
//  Recipes
//
//  Created by Styles Weiler on 12/11/24.
//


import SwiftUI
import SwiftData

struct TagManagementView: View {
    @Environment(RecipeViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    @State private var newTagName = ""
    @State private var showingDeleteAlert = false
    @State private var tagToDelete: Tag?
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        TextField("New Category Name", text: $newTagName)
                        Button("Add") {
                            if !newTagName.isEmpty {
                                _ = viewModel.createTag(name: newTagName)
                                newTagName = ""
                            }
                        }
                        .disabled(newTagName.isEmpty)
                    }
                }
                
                Section {
                    ForEach(viewModel.tags) { tag in
                        HStack {
                            Text(tag.name)
                            Spacer()
                            Text("\(tag.recipes.count) recipes")
                                .foregroundStyle(.secondary)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                tagToDelete = tag
                                showingDeleteAlert = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Manage Categories")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Delete Category?", isPresented: $showingDeleteAlert, presenting: tagToDelete) { tag in
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    viewModel.deleteTag(tag)
                }
            } message: { tag in
                Text("Are you sure you want to delete '\(tag.name)'? This will remove it from all associated recipes.")
            }
        }
    }
}
