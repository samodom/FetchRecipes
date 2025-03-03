import Foundation
@testable import Model
import Testing

struct CuisineTests {
    @Test(arguments: String.emptyAndWhitespaceOnly)
    func validName(_ name: String) {
        #expect(Cuisine(name: name, flag: .sampleFlag) == nil, .validName)
    }

    @Test func trimmedName() throws {
        let cuisine = try #require(
            Cuisine(name: .untrimmedRawCuisine, flag: .sampleFlag),
            .trimmedName
        )
        #expect(cuisine.name == .trimmedRawCuisine, .trimmedName)
    }

    @Test(
        arguments: [
            KnownCuisineValues(cuisine: .american, name: "American", flag: "🇺🇸"),
            KnownCuisineValues(cuisine: .british, name: "British", flag: "🇬🇧"),
            KnownCuisineValues(cuisine: .canadian, name: "Canadian", flag: "🇨🇦"),
            KnownCuisineValues(cuisine: .croatian, name: "Croatian", flag: "🇭🇷"),
            KnownCuisineValues(cuisine: .french, name: "French", flag: "🇫🇷"),
            KnownCuisineValues(cuisine: .greek, name: "Greek", flag: "🇬🇷"),
            KnownCuisineValues(cuisine: .italian, name: "Italian", flag: "🇮🇹"),
            KnownCuisineValues(cuisine: .malaysian, name: "Malaysian", flag: "🇲🇾"),
            KnownCuisineValues(cuisine: .polish, name: "Polish", flag: "🇵🇱"),
            KnownCuisineValues(cuisine: .portuguese, name: "Portuguese", flag: "🇵🇹"),
            KnownCuisineValues(cuisine: .russian, name: "Russian", flag: "🇷🇺"),
            KnownCuisineValues(cuisine: .tunisian, name: "Tunisian", flag: "🇹🇳"),
        ]
    )
    func knownCuisines(values: KnownCuisineValues) throws {
        #expect(values.cuisine.name == values.name, .knownName(values.name))
        #expect(values.cuisine.flag == values.flag, .flag(values.flag, for: values.cuisine))

        let knownCuisine = try #require(Cuisine.named(values.name), .knownName(values.name))
        #expect(knownCuisine.name == values.name, .knownName(values.name))
        #expect(knownCuisine.flag == values.flag, .flag(values.flag, for: values.cuisine))
    }

    @Test func trimmedLookup() throws {
        let cuisine = try #require(Cuisine.named(.untrimmedRawCuisine), .trimmedLookup)
        #expect(Cuisine.american.name == cuisine.name, .trimmedLookup)
        #expect(Cuisine.american.flag == cuisine.flag, .trimmedLookup)
    }

    @Test func unknown() throws {
        let cuisine = try #require(Cuisine.named(.untrimmedRawUnknownCuisine), .unknown)
        #expect(cuisine.name == .trimmedRawUnknownCuisine, .unknown)
        #expect(cuisine.flag == "🏴‍☠️", .unknown)
    }

    @Test(arguments: String.emptyAndWhitespaceOnly) func invalidUnknown(name: String) {
        #expect(Cuisine.named(name) == nil, .invalidLookup)
    }

    @Test func equal() {
        let cuisine1 = Cuisine.american
        let cuisine2 = Cuisine.american
        #expect(cuisine1 == cuisine2, .equality)
    }

    @Test func codable() throws {
        let encoded = try #require(try JSONEncoder().encode(Cuisine.american), .codable)
        let decoded = try #require(try JSONDecoder().decode(Cuisine.self, from: encoded), .codable)
        #expect(decoded == .american, .codable)
    }
}

// MARK: - Assertions

fileprivate extension Comment {
    static let validName: Self = "A cuisine is not represented by an empty or all-whitespace name"
    static let trimmedName: Self = "A cuisine is represented by a trimmed string"

    static func knownName(_ name: String) -> Self {
        "A built-in cuisine named '\(name)' exists"
    }

    static func flag(_ flag: String, for cuisine: Cuisine) -> Self {
        "The flag for the cuisine '\(cuisine.name)' is \(flag)"
    }

    static let trimmedLookup: Self = "A known cuisine is looked up using a trimmed name"
    static let unknown: Self = "An unknown cuisine can be created with a valid name"
    static let invalidLookup: Self = "A cuisine cannot be looked up without a valid name"
    static let equality: Self = "A cuisine with equal names and flags are equal"
    static let codable: Self = "A cuisine is codable"
}

// MARK: - Test Data

fileprivate extension String {
    static let emptyAndWhitespaceOnly = ["", "      "]
    static let untrimmedRawCuisine = "  American "
    static let trimmedRawCuisine = "American"
    static let untrimmedRawUnknownCuisine = "  Something Different    "
    static let trimmedRawUnknownCuisine = "Something Different"
    static let sampleFlag: Self = "🏁"
}

struct KnownCuisineValues {
    let cuisine: Cuisine
    let name: String
    let flag: String
}
