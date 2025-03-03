import Foundation
@testable import Model
import Testing

struct RemoteRecipeTests {

    // MARK: Identifier

    @Test(arguments: String.emptyAndWhitespaceOnly + [.invalidIdentifier])
    func invalidIdentifier(_ identifier: String) throws {
        let json = String.sampleRecipeJSON(identifier: identifier)
        expectDataCorrupted(key: .uuid, assertion: .hasUniqueIdentifier) {
            _ = try RemoteRecipe(json: json)
        }
    }

    @Test func missingIdentifier() throws {
        let json = String.sampleRecipeJSON(identifier: nil)
        expectKeyNotFound(key: .uuid, assertion: .hasUniqueIdentifier) {
            _ = try RemoteRecipe(json: json)
        }
    }

    @Test func uniqueIdentifier() throws {
        let recipe = try #require(try RemoteRecipe(json: .sampleRecipeJSON()), .hasUniqueIdentifier)
        #expect(recipe.uuid == .sample, .hasUniqueIdentifier)
    }

    // MARK: Name

    @Test(arguments: String.emptyAndWhitespaceOnly)
    func invalidName(_ name: String) throws {
        let json = String.sampleRecipeJSON(name: name)
        expectDataCorrupted(key: .name, assertion: .hasName) {
            _ = try RemoteRecipe(json: json)
        }
    }

    @Test func missingName() throws {
        let json = String.sampleRecipeJSON(name: nil)
        expectKeyNotFound(key: .name, assertion: .hasName) {
            _ = try RemoteRecipe(json: json)
        }
    }

    @Test func validName() throws {
        let recipe = try #require(try RemoteRecipe(json: .sampleRecipeJSON()), .hasName)
        #expect(recipe.name == .applePieName, .hasName)
    }

    // MARK: Cuisine

    @Test(arguments: String.emptyAndWhitespaceOnly)
    func invalidCuisine(_ cuisine: String) throws {
        let json = String.sampleRecipeJSON(cuisine: cuisine)
        expectDataCorrupted(key: .cuisine, assertion: .hasCuisine) {
            _ = try RemoteRecipe(json: json)
        }
    }

    @Test func missingCuisine() throws {
        let json = String.sampleRecipeJSON(cuisine: nil)
        expectKeyNotFound(key: .cuisine, assertion: .hasCuisine) {
            _ = try RemoteRecipe(json: json)
        }
    }

    @Test func validCuisine() throws {
        let recipe = try #require(try RemoteRecipe(json: .sampleRecipeJSON()), .hasCuisine)
        #expect(recipe.cuisine == .americanCuisine, .hasCuisine)
    }

    // MARK: Large Image

    @Test func invalidLargeImage() throws {
        let json = String.sampleRecipeJSON(largeImageLink: .unparsableURL)
        let recipe = try #require(try RemoteRecipe(json: json), .hasOptionalLargeImage)
        #expect(recipe.photo_url_large == nil, .hasOptionalLargeImage)
    }

    @Test func missingLargeImage() throws {
        let json = String.sampleRecipeJSON(largeImageLink: nil)
        let recipe = try #require(try RemoteRecipe(json: json), .hasOptionalLargeImage)
        #expect(recipe.photo_url_large == nil, .hasOptionalLargeImage)
    }

    @Test func validLargeImage() throws {
        let recipe = try #require(
            try RemoteRecipe(json: .sampleRecipeJSON()),
            .hasOptionalLargeImage
        )
        let url = try #require(URL(string: .validURL), .hasOptionalLargeImage)
        #expect(recipe.photo_url_large == url, .hasOptionalLargeImage)
    }

    // MARK: Small Image

    @Test func invalidSmallImage() throws {
        let json = String.sampleRecipeJSON(smallImageLink: .unparsableURL)
        let recipe = try #require(try RemoteRecipe(json: json), .hasOptionalSmallImage)
        #expect(recipe.photo_url_small == nil, .hasOptionalSmallImage)
    }

    @Test func missingSmallImage() throws {
        let json = String.sampleRecipeJSON(smallImageLink: nil)
        let recipe = try #require(try RemoteRecipe(json: json), .hasOptionalSmallImage)
        #expect(recipe.photo_url_small == nil, .hasOptionalSmallImage)
    }

    @Test func validSmallImage() throws {
        let recipe = try #require(
            try RemoteRecipe(json: .sampleRecipeJSON()),
            .hasOptionalSmallImage
        )
        let url = try #require(URL(string: .validURL), .hasOptionalSmallImage)
        #expect(recipe.photo_url_small == url, .hasOptionalSmallImage)
    }

    // MARK: Details Link

    @Test func invalidDetailsLink() throws {
        let json = String.sampleRecipeJSON(detailsLink: .unparsableURL)
        let recipe = try #require(try RemoteRecipe(json: json), .hasOptionalDetailsLink)
        #expect(recipe.source_url == nil, .hasOptionalDetailsLink)
    }

    @Test func missingDetailsLink() throws {
        let json = String.sampleRecipeJSON(detailsLink: nil)
        let recipe = try #require(try RemoteRecipe(json: json), .hasOptionalDetailsLink)
        #expect(recipe.source_url == nil, .hasOptionalDetailsLink)
    }

    @Test func validDetailsLink() throws {
        let recipe = try #require(
            try RemoteRecipe(json: .sampleRecipeJSON()),
            .hasOptionalDetailsLink
        )
        let url = try #require(URL(string: .validURL), .hasOptionalDetailsLink)
        #expect(recipe.source_url == url, .hasOptionalDetailsLink)
    }

    // MARK: Video Link

    @Test func invalidVideoLink() throws {
        let json = String.sampleRecipeJSON(videoLink: .unparsableURL)
        let recipe = try #require(try  RemoteRecipe(json: json), .hasOptionalVideoLink)
        #expect(recipe.youtube_url == nil, .hasOptionalVideoLink)
    }

    @Test func missingVideoLink() throws {
        let json = String.sampleRecipeJSON(videoLink: nil)
        let recipe = try #require(try RemoteRecipe(json: json), .hasOptionalVideoLink)
        #expect(recipe.youtube_url == nil, .hasOptionalVideoLink)
    }

    @Test func validVideoLink() throws {
        let recipe = try #require(
            try RemoteRecipe(json: .sampleRecipeJSON()),
            .hasOptionalVideoLink
        )
        let url = try #require(URL(string: .validURL), .hasOptionalVideoLink)
        #expect(recipe.youtube_url == url, .hasOptionalVideoLink)
    }

    // MARK: - Tools

    private func expectDataCorrupted(
        key: RemoteRecipe.CodingKeys,
        assertion: Comment,
        sourceLocation: SourceLocation = #_sourceLocation,
        performing expression: () throws -> Void
    ) {
        #expect(assertion, sourceLocation: sourceLocation) { try expression() }
        throws: { error in
            switch error as? DecodingError {
            case .dataCorrupted(let context):
                #expect(
                    context.codingPath.first as? RemoteRecipe.CodingKeys == key,
                    assertion,
                    sourceLocation: sourceLocation
                )
                return true
            default:
                return false
            }
        }
    }

    private func expectKeyNotFound(
        key: RemoteRecipe.CodingKeys,
        assertion: Comment,
        sourceLocation: SourceLocation = #_sourceLocation,
        performing expression: () throws -> Void
    ) {
        #expect(assertion, sourceLocation: sourceLocation) { try expression() }
        throws: { error in
            switch error as? DecodingError {
            case .keyNotFound(let missingKey, _):
                #expect(
                    missingKey as? RemoteRecipe.CodingKeys == key,
                    assertion,
                    sourceLocation: sourceLocation
                )
                return true
            default:
                return false
            }
        }
    }
}

// MARK: - Assertions

fileprivate extension Comment {
    static let hasUniqueIdentifier: Self = "A remote recipe has a unique identifier"
    static let hasCuisine: Self = "A remote recipe has a cuisine"
    static let hasName: Self = "A remote recipe has a non-empty name"
    static let hasOptionalSmallImage: Self = "A remote recipe has an optional small image URL"
    static let hasOptionalLargeImage: Self = "A remote recipe has an optional large image URL"
    static let hasOptionalDetailsLink: Self = "A remote recipe has an optional link to its details"
    static let hasOptionalVideoLink: Self = "A remote recipe has an optional link to a video"
}

// MARK: - Test Data

fileprivate extension String {
    static let emptyAndWhitespaceOnly = ["", "      "]
    static let invalidIdentifier = "abc-123"
    static let applePieName = "Apple Pie"
    static let americanCuisine = "American"
    static let unparsableURL = "https://something weird . com/stuff"
    static let validURL = "https://example.com/some.resource"

    static func sampleRecipeJSON(
        identifier: String? = UUID.sample.uuidString,
        cuisine: String? = .americanCuisine,
        name: String? = .applePieName,
        largeImageLink: String? = .validURL,
        smallImageLink: String? = .validURL,
        detailsLink: String? = .validURL,
        videoLink: String? = .validURL
    ) -> String {
        let json = """
        {
            \(createJSONLine(key: "uuid", value: identifier))
            \(createJSONLine(key: "name", value: name))
            \(createJSONLine(key: "cuisine", value: cuisine))
            \(createJSONLine(key: "photo_url_large", value: largeImageLink))
            \(createJSONLine(key: "photo_url_small", value: smallImageLink))
            \(createJSONLine(key: "source_url", value: detailsLink))
            \(createJSONLine(key: "youtube_url", value: videoLink))
        }
        """
        print(json)
        return json
    }

    private static func createJSONLine(key: String, value: String?) -> String {
        guard let value else { return "" }
        return #""\#(key)": "\#(value)","#
    }
}

fileprivate extension UUID {
    static let sample = Self(uuidString: "b07b8b92-64c9-4322-ab15-e628a1b8fcbc")!
}
