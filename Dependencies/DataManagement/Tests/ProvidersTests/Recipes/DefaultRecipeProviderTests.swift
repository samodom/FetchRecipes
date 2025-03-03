import Foundation
import Model
import NetworkingInterface
@testable import Providers
import SwiftData
import Testing

struct DefaultRecipeProviderTests {
    let fetcher = TestFetcher()
    let modelContainer: ModelContainer
    let provider: any RecipeProvider

    init() throws {
        modelContainer = try #require(
            try ModelContainer(
                for: Recipe.self,
                configurations: .init(for: Recipe.self, isStoredInMemoryOnly: true)
            )
        )
        provider = DefaultRecipeProvider(fetcher: fetcher, modelContainer: modelContainer)
    }

    @Test func ignoredLoading() async throws {
        await fetcher.setStubbedValues(stubbedFetchData: .sample)
        await fetcher.setIsSuspended(true)
        Task {
            try await provider.loadRecipes(at: .sample)
        }
        try await Task.sleep(nanoseconds: 1_000_000) // 1 millisecond
        Task {
            try await provider.loadRecipes(at: .sample)
        }
        try await Task.sleep(nanoseconds: 1_000_000) // 1 millisecond
        await fetcher.setIsSuspended(false)
        try await Task.sleep(nanoseconds: 1_000_000) // 1 millisecond
        #expect(await fetcher.fetchedURLs == [.sample], .loadInProgress)
    }

    @MainActor
    @Test(.disabled(.contextBug))
    func clearingRecipes() async throws {
        modelContainer.mainContext.insert(Recipe.sample)
        try modelContainer.mainContext.save()
        await fetcher.setStubbedValues(stubbedFetchData: .recipes)
        try await provider.loadRecipes(at: .sample)
        let recipes = try #require(
            try modelContainer.mainContext.fetch(FetchDescriptor<Recipe>()),
            .clearsRecipes
        )
        #expect(recipes.count == 1, .clearsRecipes)
        let result = try #require(recipes.first, .clearsRecipes)
        #expect(result.id != Recipe.sample.id, .clearsRecipes)
    }

    @Test func loadingFailure() async throws {
        let expectedError = TestError()
        await fetcher.setStubbedValues(stubbedFetchError: NetworkingError.system(expectedError))
        await #expect(.failedLoading) {
            try await provider.loadRecipes(at: .sample)
        }
        throws: { error in
            switch error as? NetworkingError {
            case .system(let wrappedError):
                wrappedError as? TestError == expectedError
            default:
                false
            }
        }
    }

    @MainActor @Test func loadingRecipes() async throws {
        await fetcher.setStubbedValues(stubbedFetchData: .recipes)
        try await provider.loadRecipes(at: .sample)
        #expect(await fetcher.fetchedURLs == [.sample], .loadsRecipes)
        let recipes = try #require(
            try  modelContainer.mainContext.fetch(FetchDescriptor<Recipe>()),
            .clearsRecipes
        )
        #expect(recipes.count == 1, .loadsRecipes)
        let recipe = try #require(recipes.first, .loadsRecipes)
        #expect(recipe.id == .sample, .loadsRecipes)
    }

    @MainActor @Test func deletingRecipes() async throws {
        modelContainer.mainContext.insert(Recipe.sample)
        try modelContainer.mainContext.save()
        try #require(
            try modelContainer.mainContext.fetch(FetchDescriptor<Recipe>()).count == 1,
            .deletesRecipes
        )
        try await provider.deleteRecipes()
        #expect(
            try modelContainer.mainContext.fetch(FetchDescriptor<Recipe>()).isEmpty,
            .deletesRecipes
        )
    }

    @MainActor @Test func defaultQuery() throws {
        let predicate = provider.queryPredicate(for: nil)
        #expect(try predicate.evaluate(.sample) == true, .predicates)
    }

    @MainActor @Test func emptySearch() throws {
        let predicate = provider.queryPredicate(for: "")
        #expect(try predicate.evaluate(.sample) == true, .predicates)
    }

    @MainActor @Test func nonEmptySearch() throws {
        let predicate = provider.queryPredicate(for: "burger")
        #expect(try predicate.evaluate(.sample) == false, .predicates)
    }
}

// MARK: - Assertions

fileprivate extension Comment {
    static let loadInProgress: Self = "A recipe provider ignores calls to load while in progress"
    static let clearsRecipes: Self = "A recipe provider deletes all recipes on a new load"
    static let loadsRecipes: Self = "A recipe provider fetches, decodes and saves recipes"
    static let failedLoading: Self = "A recipe provider handles loading failure"
    static let deletesRecipes: Self = "A recipe provider deletes all recipes"
    static let predicates: Self = "A recipe provider creates query predicates from search text"

    static let contextBug: Self = "Test disabled due to model context bug: context goes missing"
}

// MARK: - Test Values

fileprivate extension URL {
    static let sample = URL(string: "https://somewhere.com/something")!
}

fileprivate extension String {
    static let sampleUUID = "0c6ca6e7-e32a-4053-b824-1dbf749910d8"
    static let recipes =
        """
        {
            "recipes": [
                {
                    "cuisine": "Malaysian",
                    "name": "Apam Balik",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                    "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                    "uuid": "\(sampleUUID)",
                    "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
                }
            ]
        }
        """
}

fileprivate extension UUID {
    static let sample = UUID(uuidString: .sampleUUID)!
}

fileprivate extension Data {
    static let sample = Data("some string that gets fetched".utf8)
    static let recipes = Data(String.recipes.utf8)
}

fileprivate extension Recipe {
    nonisolated(unsafe) static let sample = Recipe(
        id: UUID(),
        name: "Apple Pie",
        cuisine: .american,
        largeImageURL: nil,
        smallImageURL: nil,
        detailsURL: nil,
        videoURL: nil
    )
}
