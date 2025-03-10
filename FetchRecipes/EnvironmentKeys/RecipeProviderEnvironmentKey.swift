import Model
import Providers
import SwiftUI

private struct RecipeProviderEnvironmentKey: EnvironmentKey {
    static let defaultValue: any RecipeProvider = EmptyRecipeProvider()
}

extension EnvironmentValues {
    /// An environment value for injecting a recipe provider to a view hierarchy.
    var recipeProvider: any RecipeProvider {
        get { self[RecipeProviderEnvironmentKey.self] }
        set { self[RecipeProviderEnvironmentKey.self] = newValue }
    }
}

private actor EmptyRecipeProvider: RecipeProvider {
    func loadRecipes(at url: URL) async throws {}

    func deleteRecipes() async throws {}

    nonisolated func queryPredicate(for searchText: String?) -> Predicate<Recipe> {
        #Predicate { _ in false }
    }
}
