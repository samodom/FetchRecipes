/// Represents a canonical version of a recipe's cuisine type based largely on a national/cultural
/// categorization.
public struct Cuisine: Sendable, Equatable, Codable {
    /// The name of the cuisine (i.e., "British").
    public let name: String

    /// The emoji representation of the national flag with which the cuisine is associated.
    public let flag: String

    private enum CodingKeys: String, CodingKey {
        case name
        case flag
    }

    /// Creates a cuisine from the provided values.
    /// - Parameter name: The name of the cuisine which must be trimmable to a non-empty value.
    /// - Parameter flag: The emoji representing the national flag of the cuisine.
    init?(name: String, flag: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return nil }

        self.name = trimmedName
        self.flag = flag
    }

    /// Decodes a cuisine from a provided decoder.
    /// - Parameter decoder: The decoder from which to decode the encoded data.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        flag = try container.decode(String.self, forKey: .flag)
    }

    /// Encodes a cuisine to a provided encoder.
    /// - Parameter encoder: The encoder to which to encode the cuisine.
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(flag, forKey: .flag)
    }

    /// The "American" cuisine.
    public static let american = Cuisine(name: "American", flag: "🇺🇸")!

    /// The "British" cuisine.
    public static let british = Cuisine(name: "British", flag: "🇬🇧")!

    /// The "Canadian" cuisine.
    public static let canadian = Cuisine(name: "Canadian", flag: "🇨🇦")!

    /// The "Croatian" cuisine.
    public static let croatian = Cuisine(name: "Croatian", flag: "🇭🇷")!

    /// The "French" cuisine.
    public static let french = Cuisine(name: "French", flag: "🇫🇷")!

    /// The "Greek" cuisine.
    public static let greek = Cuisine(name: "Greek", flag: "🇬🇷")!

    /// The "Italian" cuisine.
    public static let italian = Cuisine(name: "Italian", flag: "🇮🇹")!

    /// The "Malaysian" cuisine.
    public static let malaysian = Cuisine(name: "Malaysian", flag: "🇲🇾")!

    /// The "Polish" cuisine.
    public static let polish = Cuisine(name: "Polish", flag: "🇵🇱")!

    /// The "Portuguese" cuisine.
    public static let portuguese = Cuisine(name: "Portuguese", flag: "🇵🇹")!

    /// The "Russian" cuisine.
    public static let russian = Cuisine(name: "Russian", flag: "🇷🇺")!

    /// The "Tunisian" cuisine.
    public static let tunisian = Cuisine(name: "Tunisian", flag: "🇹🇳")!

    private static let knownCuisines: [String: Self] = {
        [
            american,
            british,
            canadian,
            croatian,
            french,
            greek,
            italian,
            malaysian,
            polish,
            portuguese,
            russian,
            tunisian,
        ]
            .reduce(into: [:]) { known, cuisine in
                known[cuisine.name] = cuisine
            }
    }()

    /// Looks up a known cuisine by its name if it exists.
    /// - Parameter name: The name of the cuisine to look up.
    /// - Returns: The known cuisine if found or an unknown cuisine with a Jolly Roger flag if the
    /// cuisine name is invalid.
    public static func named(_ name: String) -> Cuisine? {
        let name = name.trimmingCharacters(in: .whitespaces)
        return knownCuisines[name] ?? Self(name: name, flag: "🏴‍☠️")
    }
}
