import Foundation
import Model
import SwiftData
import SwiftUI

/// Manages loading, storing and querying recipes originating at a URL.
public protocol RecipeProvider: Actor {
    /// Asynchronously loads and stores recipes from a given URL
    /// - Parameter url: The URL from which to retrieve a list of recipes.
    /// - Throws: Any error that occurs from loading, parsing or storing a list of recipes.
    func loadRecipes(at url: URL) async throws

    /// Asynchronously removes all stored recipes.
    func deleteRecipes() async throws

    /// Creates query predicates for use in model-based views.
    /// - Parameter searchText: Any given text used to search a list of recipes.
    /// - Returns: A predicate for a recipe query based on the provided search text.
    @MainActor func queryPredicate(for searchText: String?) -> Predicate<Recipe>
}
