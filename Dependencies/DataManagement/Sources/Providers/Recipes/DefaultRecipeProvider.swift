import Foundation
import Model
import NetworkingInterface
import SwiftData
import SwiftUI

/// A `SwiftData`-backed provider of recipes.
public actor DefaultRecipeProvider: RecipeProvider {
    private let fetcher: any RemoteResourceFetching
    private let modelContext: ModelContext
    private var isLoadingInProgress = false

    /// Creates a recipe provider with a provided recipe fetcher and `SwiftData` model container.
    /// - Parameter fetcher: A remote resource fetcher that loads encoded recipe data.
    /// - Parameter modelContainer: A `SwiftData` model container from which a context is created.
    public init(fetcher: RemoteResourceFetching, modelContainer: ModelContainer) {
        self.fetcher = fetcher
        self.modelContext = ModelContext(modelContainer)
    }

    /// Asynchronously loads and stores recipes from a given URL
    /// - Parameter url: The URL from which to retrieve a list of recipes.
    /// - Throws: Any error that occurs from loading, parsing or storing a list of recipes.
    public func loadRecipes(at url: URL) async throws {
        guard !isLoadingInProgress else { return }

        isLoadingInProgress = true
        try await deleteRecipes()
        try modelContext.save()

        defer { isLoadingInProgress = false }

        do {
            let data = try await fetcher.fetch(from: url)
            let remoteRecipeList = try JSONDecoder().decode(RemoteRecipeList.self, from: data)
            try remoteRecipeList.recipes.forEach { remoteRecipe in
                let recipe = try Recipe(from: remoteRecipe)
                modelContext.insert(recipe)
            }
            try modelContext.save()
        }
        catch {
            modelContext.rollback()
            throw error
        }
    }

    /// Asynchronously removes all stored recipes.
    public func deleteRecipes() async throws {
        try modelContext.delete(model: Recipe.self)
        try modelContext.save()
    }

    /// Creates query predicates for use in model-based views.
    /// - Parameter searchText: Any given text used to search a list of recipes.
    /// - Returns: A predicate for a recipe query based on the provided search text.
    public nonisolated func queryPredicate(for searchText: String?) -> Predicate<Recipe> {
        let queryText = searchText ?? ""
        return #Predicate { recipe in
            if queryText.isEmpty { true }
            else { recipe.name.contains(queryText) }
        }
    }
}
