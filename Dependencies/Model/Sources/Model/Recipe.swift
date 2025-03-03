import Foundation
import SwiftData

/// Represents a `SwiftData`-backed domain model of a recipe.
@Model public class Recipe {
    /// The unique identifier of the recipe.
    @Attribute(.unique) public var id: UUID

    /// The name of the recipe.
    public var name: String

    /// The cuisine of the recipe.
    public var cuisine: Cuisine

    /// The URL of a large image representing the recipe if it exists.
    public var largeImageURL: URL?

    /// The URL of a small image representing the recipe if it exists.
    public var smallImageURL: URL?

    /// The URL of the details representing the recipe if it exists.
    public var detailsURL: URL?

    /// The URL of a video representing the recipe if it exists.
    public var videoURL: URL?

    /// A flag to indicate whether a user has specified the recipe as having been prepared before.
    public var hasBeenPrepared = false

    /// Creates a recipe with the provided values.
    /// - Parameter id: The unique identifier to associate with the recipe.
    /// - Parameter name: The name of the recipe.
    /// - Parameter cuisine: The cuisine of the recipe.
    /// - Parameter largeImageURL: The URL of a large image representing the recipe if it exists.
    /// - Parameter smallImageURL: The URL of a small image representing the recipe if it exists.
    /// - Parameter detailsURL: The URL of the details representing the recipe if it exists.
    /// - Parameter videoURL: The URL of a video representing the recipe if it exists.
    public init(
        id: UUID,
        name: String,
        cuisine: Cuisine,
        largeImageURL: URL?,
        smallImageURL: URL?,
        detailsURL: URL?,
        videoURL: URL?
    ) {
        self.id = id
        self.name = name
        self.cuisine = cuisine
        self.largeImageURL = largeImageURL
        self.smallImageURL = smallImageURL
        self.detailsURL = detailsURL
        self.videoURL = videoURL
    }

    /// Creates a recipe from a known remote representation.
    /// - Parameter recipe: The remote recipe representation.
    /// - Throws: An internal error representing a failure to find or create a cuisine.
    public convenience init(from recipe: RemoteRecipe) throws {
        struct RemoteRecipeMappingError: Error {}

        guard let cuisine = Cuisine.named(recipe.cuisine)
        else { throw RemoteRecipeMappingError() }

        self.init(
            id: recipe.uuid,
            name: recipe.name,
            cuisine: cuisine,
            largeImageURL: recipe.photo_url_large,
            smallImageURL: recipe.photo_url_small,
            detailsURL: recipe.source_url,
            videoURL: recipe.youtube_url
        )
    }
}
