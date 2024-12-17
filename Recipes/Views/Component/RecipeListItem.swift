//
//  RecipeListItem.swift
//  Recipes
//
//  Created by Styles Weiler on 12/2/24.
//


import Foundation
import SwiftUI
import SwiftData

struct RecipeListItem: View {
    let recipe: Recipe
    @Environment(RecipeViewModel.self) private var viewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(recipe.title)
                    .font(.headline)
                if let origin = recipe.countryOfOrigin {
                    Image(origin)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 20)
                }
                Spacer()
            }
            HStack {
                Text("Prep time: \(String(describing: recipe.prepTime ?? 0)) mins")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 8)
        }
    }
}
