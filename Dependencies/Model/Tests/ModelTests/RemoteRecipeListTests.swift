import Foundation
import Model
import Testing

struct RemoteRecipeListTests {
    @Test func empty() throws {
        let data = try #require(loadJSONFile(named: "recipes-empty"), .emptyList)
        let recipeList = try #require(
            try JSONDecoder().decode(RemoteRecipeList.self, from: data),
            .emptyList
        )
        #expect(recipeList.recipes.isEmpty, .emptyList)
    }

    @Test func malformed() throws {
        let data = try #require(loadJSONFile(named: "recipes-malformed"), .invalidList)
        #expect(throws: DecodingError.self, .invalidList) {
            _ = try JSONDecoder().decode(RemoteRecipeList.self, from: data)
        }
    }

    @Test func valid() throws {
        let data = try #require(loadJSONFile(named: "recipes"), .validList)
        let recipeList = try #require(
            try JSONDecoder().decode(RemoteRecipeList.self, from: data),
            .validList
        )
        #expect(recipeList.recipes.count == 63, .validList)
    }

    // MARK: - Tools

    private func loadJSONFile(named name: String) -> Data? {
        guard let url = Bundle.module.url(forResource: name, withExtension: "json")
        else { return nil }

        return try? Data(contentsOf: url)
    }
}

// MARK: - Assertions

fileprivate extension Comment {
    static let emptyList: Self = "An empty JSON recipe list yields an empty list of remote recipes"
    static let invalidList: Self = "A malformed JSON recipe list yields a parsing error"
    static let validList: Self = "A valid JSON recipe list yields a list of remote recipes"
}
