import Foundation
@testable import Model
import Testing

struct RecipeTests {
    @Test func identifier() {
        let recipe = makeRecipe()
        #expect(recipe.id == .sample, .hasIdentifier)
    }

    @Test func name() {
        let recipe = makeRecipe()
        #expect(recipe.name == .applePieName, .hasName)
    }

    @Test func cuisine() {
        let recipe = makeRecipe()
        #expect(recipe.cuisine.name == Cuisine.american.name, .hasCuisine)
        #expect(recipe.cuisine.flag == Cuisine.american.flag, .hasCuisine)
    }

    @Test func missingLargeImageURL() {
        let recipe = makeRecipe(hasLargeImage: false)
        #expect(recipe.largeImageURL == nil, .hasOptionalLargeImageLink)
    }

    @Test func largeImageURL() {
        let recipe = makeRecipe()
        #expect(recipe.largeImageURL == .largeImage, .hasOptionalLargeImageLink)
    }

    @Test func missingSmallImageURL() {
        let recipe = makeRecipe(hasSmallImage: false)
        #expect(recipe.smallImageURL == nil, .hasOptionalSmallImageLink)
    }

    @Test func smallImageURL() {
        let recipe = makeRecipe()
        #expect(recipe.smallImageURL == .smallImage, .hasOptionalSmallImageLink)
    }

    @Test func missingDetailsURL() {
        let recipe = makeRecipe(hasDetails: false)
        #expect(recipe.detailsURL == nil, .hasOptionalDetailsLink)
    }

    @Test func detailsURL() {
        let recipe = makeRecipe()
        #expect(recipe.detailsURL == .details, .hasOptionalDetailsLink)
    }

    @Test func missingVideoURL() {
        let recipe = makeRecipe(hasVideo: false)
        #expect(recipe.videoURL == nil, .hasOptionalVideoLink)
    }

    @Test func videoURL() {
        let recipe = makeRecipe()
        #expect(recipe.videoURL == .video, .hasOptionalVideoLink)
    }

    @Test func removeRecipeInvalidMapping() {
        #expect(throws: (any Error).self, .mappingFromInvalidRemoteRecipe) {
            _ = try Recipe(from: .invalid)
        }
    }

    @Test func remoteRecipeMapping() throws {
        let recipe = try #require(try Recipe(from: .applePie), .mappingFromValidRemoteRecipe)
        #expect(recipe.id == .sample, .mappingFromValidRemoteRecipe)
        #expect(recipe.name == .applePieName, .mappingFromValidRemoteRecipe)
        #expect(recipe.cuisine == .american, .mappingFromValidRemoteRecipe)
        #expect(recipe.largeImageURL == .largeImage, .mappingFromValidRemoteRecipe)
        #expect(recipe.smallImageURL == .smallImage, .mappingFromValidRemoteRecipe)
        #expect(recipe.detailsURL == .details, .mappingFromValidRemoteRecipe)
        #expect(recipe.videoURL == .video, .mappingFromValidRemoteRecipe)
    }

    // MARK: - Tools

    private func makeRecipe(
        hasLargeImage: Bool = true,
        hasSmallImage: Bool = true,
        hasDetails: Bool = true,
        hasVideo: Bool = true
    ) -> Recipe {
        Recipe(
            id: .sample,
            name: .applePieName,
            cuisine: .american,
            largeImageURL: hasLargeImage ? .largeImage : nil,
            smallImageURL: hasSmallImage ? .smallImage : nil,
            detailsURL: hasDetails ? .details : nil,
            videoURL: hasVideo ? .video : nil
        )
    }
}

// MARK: - Assertions

fileprivate extension Comment {
    static let hasIdentifier: Self = "A recipe has a unique identifier"
    static let hasCuisine: Self = "A recipe has a cuisine"
    static let hasName: Self = "A recipe has a name"
    static let hasOptionalSmallImageLink: Self = "A recipe has an optional small image URL"
    static let hasOptionalLargeImageLink: Self = "A recipe has an optional large image URL"
    static let hasOptionalDetailsLink: Self = "A recipe has an optional link to its details"
    static let hasOptionalVideoLink: Self = "A recipe has an optional link to a video"
    static let mappingFromInvalidRemoteRecipe: Self = "A recipe can be mapped from a remote recipe"
    static let mappingFromValidRemoteRecipe: Self = "A recipe can be mapped from a remote recipe"
}

// MARK: - Test Data

fileprivate extension String {
    static let applePieName = "Apple Pie"
}

fileprivate extension URL {
    static let smallImage = URL(string: "https://example.com/small.jpg")!
    static let largeImage = URL(string: "https://example.com/large.jpg")!
    static let details = URL(string: "https://example.com/recipes/applePie.txt")!
    static let video = URL(string: "https://example.com/recipes/applePie.mp4")!
}

fileprivate extension UUID {
    static let sample = UUID(uuidString: "b07b8b92-64c9-4322-ab15-e628a1b8fcbc")!
}

fileprivate extension RemoteRecipe {
    static let invalid =  RemoteRecipe(
        uuid: .sample,
        name: .applePieName,
        cuisine: "",
        photo_url_large: .largeImage,
        photo_url_small: .smallImage,
        source_url: .details,
        youtube_url: .video
    )

    static let applePie = RemoteRecipe(
        uuid: .sample,
        name: .applePieName,
        cuisine: Cuisine.american.name,
        photo_url_large: .largeImage,
        photo_url_small: .smallImage,
        source_url: .details,
        youtube_url: .video
    )
}
