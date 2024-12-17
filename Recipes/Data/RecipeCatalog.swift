import Foundation
import SwiftData

class RecipeCatalog {
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func importDefaultRecipes() {
        print("Starting recipe import...")
        
        // Create default recipes
        let recipes = createDefaultRecipes()
        
        // Fetch existing tags
        let tagDescriptor = FetchDescriptor<Tag>()
        let tags = (try? modelContext.fetch(tagDescriptor)) ?? []
        print("Found \(tags.count) tags")
        
        for recipe in recipes {
            print("Creating recipe: \(recipe.title)")
            modelContext.insert(recipe)
            
            // Add ingredients
            let ingredients = createDefaultIngredients(for: recipe)
            for ingredient in ingredients {
                print("Adding ingredient: \(ingredient.quantity) \(ingredient.label ?? "")")
                modelContext.insert(ingredient)
                ingredient.recipe = recipe
                recipe.ingredients.append(ingredient)
            }
            
            // Add instructions
            let instructions = createDefaultInstructions(for: recipe)
            for instruction in instructions {
                print("Adding instruction: Step \(instruction.order)")
                modelContext.insert(instruction)
                instruction.recipe = recipe
                recipe.instructions.append(instruction)
            }
            
            // Add tags
            addDefaultTags(to: recipe, availableTags: tags)
            
            try? modelContext.save()
        }
        
        print("Recipe import completed")
        try? modelContext.save()
    }
    
    private func createDefaultRecipes() -> [Recipe] {
        [
            Recipe(
                title: "Classic Chocolate Chip Cookies",
                countryOfOrigin: "America",
                author: "Sarah Baker",
                dateCreated: Date(),
                prepTime: 45,
                servings: 24,
                expertiseRequired: "Beginner",
                caloriesPerServing: 150,
                isFavorite: false
            ),
            Recipe(
                title: "Authentic Spaghetti Carbonara",
                countryOfOrigin: "Italy",
                author: "Marco Rossi",
                dateCreated: Date(),
                prepTime: 30,
                servings: 4,
                expertiseRequired: "Intermediate",
                caloriesPerServing: 380,
                isFavorite: false
            ),
            Recipe(
                title: "Classic French Toast",
                countryOfOrigin: "France",
                author: "Pierre Dubois",
                dateCreated: Date(),
                prepTime: 20,
                servings: 4,
                expertiseRequired: "Beginner",
                caloriesPerServing: 250,
                isFavorite: false
            ),
            Recipe(
                title: "Fish Amok",
                countryOfOrigin: "Cambodia",
                author: "Sokha Chhum",
                dateCreated: Date(),
                prepTime: 60,
                servings: 6,
                expertiseRequired: "Advanced",
                caloriesPerServing: 320,
                isFavorite: false
            ),
            Recipe(
                title: "Gluten-Free Banana Bread",
                countryOfOrigin: "America",
                author: "Emma Wells",
                dateCreated: Date(),
                prepTime: 65,
                servings: 12,
                expertiseRequired: "Intermediate",
                caloriesPerServing: 180,
                isFavorite: false
            ),
            Recipe(
                title: "Traditional Tiramisu",
                countryOfOrigin: "Italy",
                author: "Sofia Conti",
                dateCreated: Date(),
                prepTime: 40,
                servings: 8,
                expertiseRequired: "Advanced",
                caloriesPerServing: 420,
                isFavorite: false
            )
        ]
    }
    
    private func createDefaultIngredients(for recipe: Recipe) -> [Ingredient] {
        switch recipe.title {
        case "Classic Chocolate Chip Cookies":
            return [
                Ingredient(quantity: "2 1/4 cups", label: "all-purpose flour"),
                Ingredient(quantity: "1 cup", label: "butter, softened"),
                Ingredient(quantity: "3/4 cup", label: "granulated sugar"),
                Ingredient(quantity: "3/4 cup", label: "brown sugar"),
                Ingredient(quantity: "2", label: "large eggs"),
                Ingredient(quantity: "2 cups", label: "chocolate chips")
            ]
        case "Authentic Spaghetti Carbonara":
            return [
                Ingredient(quantity: "1 pound", label: "spaghetti"),
                Ingredient(quantity: "4 ounces", label: "guanciale"),
                Ingredient(quantity: "4", label: "large eggs"),
                Ingredient(quantity: "1 cup", label: "Pecorino Romano"),
                Ingredient(quantity: "1 cup", label: "Parmigiano-Reggiano")
            ]
        case "Fish Amok":
            return [
                Ingredient(quantity: "1 pound", label: "white fish fillets"),
                Ingredient(quantity: "2 tablespoons", label: "red curry paste"),
                Ingredient(quantity: "1 cup", label: "coconut milk"),
                Ingredient(quantity: "2", label: "kaffir lime leaves"),
                Ingredient(quantity: "1 tablespoon", label: "fish sauce")
            ]
        case "Classic French Toast":
            return [
                Ingredient(quantity: "6 slices", label: "thick bread"),
                Ingredient(quantity: "2", label: "large eggs"),
                Ingredient(quantity: "2/3 cup", label: "milk"),
                Ingredient(quantity: "1 teaspoon", label: "vanilla extract"),
                Ingredient(quantity: "1/4 teaspoon", label: "cinnamon")
            ]
        case "Gluten-Free Banana Bread":
            return [
                Ingredient(quantity: "3", label: "ripe bananas"),
                Ingredient(quantity: "2 cups", label: "gluten-free flour blend"),
                Ingredient(quantity: "1/2 cup", label: "butter"),
                Ingredient(quantity: "2", label: "eggs"),
                Ingredient(quantity: "1 teaspoon", label: "baking soda")
            ]
        case "Traditional Tiramisu":
            return [
                Ingredient(quantity: "6", label: "egg yolks"),
                Ingredient(quantity: "1 cup", label: "mascarpone"),
                Ingredient(quantity: "24", label: "ladyfingers"),
                Ingredient(quantity: "1 cup", label: "strong coffee"),
                Ingredient(quantity: "2 tablespoons", label: "cocoa powder")
            ]
        default:
            return []
        }
    }
    
    private func createDefaultInstructions(for recipe: Recipe) -> [Instruction] {
        switch recipe.title {
        case "Classic Chocolate Chip Cookies":
            return [
                Instruction(order: 1, content: "Preheat oven to 375°F"),
                Instruction(order: 2, content: "Cream together butter and sugars"),
                Instruction(order: 3, content: "Beat in eggs one at a time"),
                Instruction(order: 4, content: "Mix in dry ingredients"),
                Instruction(order: 5, content: "Stir in chocolate chips"),
                Instruction(order: 6, content: "Drop spoonfuls onto baking sheets"),
                Instruction(order: 7, content: "Bake for 10-12 minutes")
            ]
        case "Authentic Spaghetti Carbonara":
            return [
                Instruction(order: 1, content: "Bring large pot of salted water to boil"),
                Instruction(order: 2, content: "Cook spaghetti al dente"),
                Instruction(order: 3, content: "Crisp guanciale in pan"),
                Instruction(order: 4, content: "Mix eggs and cheese"),
                Instruction(order: 5, content: "Toss hot pasta with egg mixture"),
                Instruction(order: 6, content: "Add pasta water as needed")
            ]
        case "Classic French Toast":
            return [
                Instruction(order: 1, content: "Whisk together eggs, milk, vanilla, and cinnamon"),
                Instruction(order: 2, content: "Heat griddle or pan over medium heat"),
                Instruction(order: 3, content: "Dip bread slices in egg mixture"),
                Instruction(order: 4, content: "Cook until golden brown on both sides"),
                Instruction(order: 5, content: "Serve with maple syrup")
            ]
        case "Fish Amok":
            return [
                Instruction(order: 1, content: "Mix curry paste with coconut milk"),
                Instruction(order: 2, content: "Season fish with fish sauce"),
                Instruction(order: 3, content: "Steam in banana leaf bowls"),
                Instruction(order: 4, content: "Garnish with kaffir lime leaves")
            ]
        case "Gluten-Free Banana Bread":
            return [
                Instruction(order: 1, content: "Preheat oven to 350°F"),
                Instruction(order: 2, content: "Mash bananas"),
                Instruction(order: 3, content: "Mix wet and dry ingredients separately"),
                Instruction(order: 4, content: "Combine mixtures"),
                Instruction(order: 5, content: "Bake for 60 minutes")
            ]
        case "Traditional Tiramisu":
            return [
                Instruction(order: 1, content: "Make coffee and let cool"),
                Instruction(order: 2, content: "Beat egg yolks with mascarpone"),
                Instruction(order: 3, content: "Dip ladyfingers in coffee"),
                Instruction(order: 4, content: "Layer soaked ladyfingers and cream"),
                Instruction(order: 5, content: "Dust with cocoa powder"),
                Instruction(order: 6, content: "Chill for at least 4 hours")
            ]
        default:
            return []
        }
    }
    
    private func addDefaultTags(to recipe: Recipe, availableTags: [Tag]) {
        switch recipe.title {
        case "Classic Chocolate Chip Cookies":
            if let dessertTag = availableTags.first(where: { $0.name == "Desserts" }),
               let americanTag = availableTags.first(where: { $0.name == "American Classics" }) {
                recipe.tags.append(dessertTag)
                dessertTag.recipes.append(recipe)
                recipe.tags.append(americanTag)
                americanTag.recipes.append(recipe)
            }
        case "Authentic Spaghetti Carbonara":
            if let italianTag = availableTags.first(where: { $0.name == "Italian Dishes" }) {
                recipe.tags.append(italianTag)
                italianTag.recipes.append(recipe)
            }
        case "Classic French Toast":
            if let breakfastTag = availableTags.first(where: { $0.name == "Breakfast" }) {
                recipe.tags.append(breakfastTag)
                breakfastTag.recipes.append(recipe)
            }
        case "Gluten-Free Banana Bread":
            if let glutenFreeTag = availableTags.first(where: { $0.name == "Gluten-Free" }) {
                recipe.tags.append(glutenFreeTag)
                glutenFreeTag.recipes.append(recipe)
            }
        case "Traditional Tiramisu":
            if let dessertTag = availableTags.first(where: { $0.name == "Desserts" }),
               let italianTag = availableTags.first(where: { $0.name == "Italian Dishes" }) {
                recipe.tags.append(dessertTag)
                dessertTag.recipes.append(recipe)
                recipe.tags.append(italianTag)
                italianTag.recipes.append(recipe)
            }
        default:
            break
        }
    }
}
