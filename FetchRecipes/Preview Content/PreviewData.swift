#if DEBUG
import Foundation
import Model
import Providers
import SwiftData

@MainActor final class PreviewData {
    let modelContainer: ModelContainer
    let recipeProvider: any RecipeProvider

    init() {
        modelContainer = try! ModelContainer(
            for: Recipe.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        recipeProvider = PreviewRecipeProvider(modelContainer: modelContainer)
    }
}

private actor PreviewRecipeProvider: RecipeProvider {
    private let modelContainer: ModelContainer

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    private struct FetchError: Error {
        let description: String
    }

    func loadRecipes(at url: URL) async throws {
        guard let url = Bundle.main.url(forResource: "recipes", withExtension: "json"),
              let json = try? String(contentsOf: url, encoding: .utf8)
        else {
            throw FetchError(description: "Cannot load sample JSON file")
        }

        guard let list = try? JSONDecoder().decode(RemoteRecipeList.self, from: Data(json.utf8))
        else {
            throw FetchError(description: "Cannot parse sample JSON file")
        }

        try await insertRecipes(from: list)
    }

    @MainActor private func insertRecipes(from remoteRecipeList: RemoteRecipeList) async throws {
        guard let recipes = try? remoteRecipeList.recipes.map(Recipe.init(from:))
        else { throw FetchError(description: "Cannot create model objects from sample data") }

        recipes.forEach {
            modelContainer.mainContext.insert($0)
        }
    }

    @MainActor func deleteRecipes() async throws {
        try modelContainer.mainContext.delete(model: Recipe.self)
    }

    @MainActor func queryPredicate(for searchText: String?) -> Predicate<Recipe> {
        #Predicate { _ in false }
    }
}
#endif
