//
//  RecipeDetailsSection.swift
//  Recipes
//
//  Created by Styles Weiler on 12/9/24.
//

import Foundation
import SwiftUI

struct RecipeDetailsSection: View {
    @Binding var title: String
    @Binding var countryOfOrigin: String?
    @Binding var author: String?
    @Binding var prepTime: Int?
    @Binding var servings: Int?
    @Binding var expertiseRequired: String?
    @Binding var caloriesPerServing: Int?
    @Binding var isFavorite: Bool
    @Binding var showingFlagSelector: Bool
    
    var body: some View {
        Section(header: Text("Recipe Details")) {
            TextField("Title", text: $title)
            Button(action: { showingFlagSelector = true }) {
                HStack {
                    Text(countryOfOrigin ?? "Country of Origin")
                    Spacer()
                    if let origin = countryOfOrigin {
                        Image(origin.lowercased())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 20)
                    }
                }
            }
            TextField("Author", text: Binding(
                get: { author ?? "" },
                set: { author = $0.isEmpty ? nil : $0 }
            ))
            Stepper("Prep Time: \(prepTime ?? 0) mins", value: Binding(
                get: { prepTime ?? 0 },
                set: { prepTime = $0 }
            ), in: 0...240)
            Stepper("Servings: \(servings ?? 0)", value: Binding(
                get: { servings ?? 0 },
                set: { servings = $0 }
            ), in: 1...20)
            TextField("Expertise Required", text: Binding(
                get: { expertiseRequired ?? "" },
                set: { expertiseRequired = $0.isEmpty ? nil : $0 }
            ))
            Stepper("Calories per Serving: \(caloriesPerServing ?? 0)", value: Binding(
                get: { caloriesPerServing ?? 0 },
                set: { caloriesPerServing = $0 }
            ), in: 0...2000)
            Toggle("Is Favorite", isOn: $isFavorite)
        }
    }
}
