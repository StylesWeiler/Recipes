//
//  CategoryMenuView.swift
//  Recipes
//
//  Created by Styles Weiler on 12/11/24.
//

import SwiftUI
import SwiftData

struct CategoryMenuView: View {
    @Environment(RecipeViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTag: Tag?
    @State var showingTagManagement = false
    
    var body: some View {
        NavigationStack {
            List {
                Button {
                    selectedTag = nil
                    dismiss()
                } label: {
                    HStack {
                        Text("All Recipes")
                        Spacer()
                        if selectedTag == nil {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
                ForEach(viewModel.tags, id: \.tagId) { tag in
                    Button {
                        selectedTag = (selectedTag == tag) ? nil : tag
                        dismiss()
                    } label: {
                        HStack {
                            Text(tag.name)
                            Spacer()
                            if selectedTag == tag {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingTagManagement = true
                        dismiss()
                    } label: {
                        Text("Manage")
                    }
                }
            }
            .sheet(isPresented: $showingTagManagement) {
                TagManagementView()
            }
        }
    }
}
