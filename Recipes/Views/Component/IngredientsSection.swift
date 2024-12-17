//
//  IngredientsSection.swift
//  Recipes
//
//  Created by Styles Weiler on 12/9/24.
//

import Foundation
import SwiftUI

struct IngredientsSection: View {
    @Binding var ingredients: [Ingredient]
    
    var body: some View {
        Section(header: Text("Ingredients")) {
            ForEach(ingredients.indices, id: \.self) { index in
                HStack {
                    TextField("Quantity", text: $ingredients[index].quantity)
                        .frame(width: 100)
                    TextField("Ingredient", text: Binding(
                        get: { ingredients[index].label ?? "" },
                        set: { ingredients[index].label = $0.isEmpty ? nil : $0 }
                    ))
                }
            }
            .onDelete { indexSet in
                ingredients.remove(atOffsets: indexSet)
            }
            Button("Add Ingredient") {
                ingredients.append(Ingredient(quantity: "", label: ""))
            }
        }
    }
}
