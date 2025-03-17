import Model
import Providers
import SwiftUI

extension EnvironmentValues {
    /// An environment value for injecting a recipe provider to a view hierarchy.
    @Entry var recipeProvider: any RecipeProvider = EmptyRecipeProvider()
}

private actor EmptyRecipeProvider: RecipeProvider {
    func loadRecipes(at url: URL) async throws {}

    func deleteRecipes() async throws {}

    nonisolated func queryPredicate(for searchText: String?) -> Predicate<Recipe> {
        #Predicate { _ in false }
    }
}
