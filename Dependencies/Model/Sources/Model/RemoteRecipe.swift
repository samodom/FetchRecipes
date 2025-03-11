import Foundation

/// A model of the JSON representation of a recipe provided by the server API.
public struct RemoteRecipe: Decodable, Sendable {

    /// The unique identifier of the recipe.
    public let uuid: UUID

    /// The name of the recipe.
    public let name: String

    /// The cuisine of the recipe.
    public let cuisine: String

    /// The URL of a large image representing the recipe if it exists.
    public let photo_url_large: URL?

    /// The URL of a small image representing the recipe if it exists.
    public let photo_url_small: URL?

    /// The URL of the details representing the recipe if it exists.
    public let source_url: URL?

    /// The URL of a video representing the recipe if it exists.
    public let youtube_url: URL?

    enum CodingKeys: String, CodingKey {
        case uuid
        case name
        case cuisine
        case photo_url_large
        case photo_url_small
        case source_url
        case youtube_url
    }

    /// Decodes a remote recipe from a provided decoder.
    /// - Parameter decoder: The decoder from which to decode the encoded data.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

//        let uuid = try container.decode(UUID.self, forKey: .uuid)
        let uuid = UUID()

        let name = try container.decode(String.self, forKey: .name)
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else {
            throw DecodingError.dataCorruptedError(
                forKey: .name,
                in: container,
                debugDescription: "A recipe name must be trimmable to a non-empty string"
            )
        }

        let cuisine = try container.decode(String.self, forKey: .cuisine)
        let trimmedCuisine = cuisine.trimmingCharacters(in: .whitespaces)
        guard !trimmedCuisine.isEmpty else {
            throw DecodingError.dataCorruptedError(
                forKey: .cuisine,
                in: container,
                debugDescription: "A recipe cuisine must be trimmable to a non-empty string"
            )
        }

        self.init(
            uuid: uuid,
            name: trimmedName,
            cuisine: trimmedCuisine,
            photo_url_large: try? container.decodeIfPresent(URL.self, forKey: .photo_url_large),
            photo_url_small: try? container.decodeIfPresent(URL.self, forKey: .photo_url_small),
            source_url: try? container.decodeIfPresent(URL.self, forKey: .source_url),
            youtube_url: try? container.decodeIfPresent(URL.self, forKey: .youtube_url)
        )
    }

    /// Decodes a remote recipe from a provided decoder with data represented in JSON form.
    /// - Parameter json: The raw JSON encoding of a recipe
    public init(json: String) throws {
        self = try JSONDecoder().decode(Self.self, from: Data(json.utf8))
    }

    /// Creates a recipe from raw values.
    init(
        uuid: UUID,
        name: String,
        cuisine: String,
        photo_url_large: URL?,
        photo_url_small: URL?,
        source_url: URL?,
        youtube_url: URL?
    ) {
        self.uuid = uuid
        self.name = name
        self.cuisine = cuisine
        self.photo_url_large = photo_url_large
        self.photo_url_small = photo_url_small
        self.source_url = source_url
        self.youtube_url = youtube_url
    }
}
