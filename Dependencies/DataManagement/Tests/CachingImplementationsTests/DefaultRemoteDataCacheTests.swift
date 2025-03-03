import CachingInterface
import CachingImplementations
import Foundation
import Testing

struct DefaultRemoteDataCacheTests {
    let urlCache = URLCache(
        memoryCapacity: Data.sampleValue.count * 2,
        diskCapacity: Data.sampleValue.count * 2,
        diskPath: nil
    )
    let cache: DefaultRemoteDataCache
    let request = URLRequest(url: .sampleKey)
    let response = CachedURLResponse(response: .sample, data: .sampleValue)

    init() throws {
        urlCache.removeCachedResponses(since: .distantPast)
        cache = DefaultRemoteDataCache(urlCache: urlCache)
        try #require(urlCache.cachedResponse(for: request) == nil)
    }

    @Test func storing() throws {
        cache.store(.sampleValue, for: .sampleKey)
        let response = try #require(urlCache.cachedResponse(for: request))
        #expect(response.response.url == .sampleKey, .storeValue)
        #expect(response.data == .sampleValue, .storeValue)
    }

    @Test func missing() throws {
        try #require(cache.value(for: .missingKey) == nil, .missingValue)
    }

    @Test func retrieving() throws {
        urlCache.storeCachedResponse(response, for: request)
        let value = try #require(cache.value(for: .sampleKey))
        #expect(value == .sampleValue, .retrieveValue)
    }

    @Test(.disabled(.cacheBug)) func clearing() {
        urlCache.storeCachedResponse(response, for: request)
        cache.clear()
        #expect(urlCache.cachedResponse(for: request) == nil, .clearValues)
    }
}

// MARK: - Assertions

fileprivate extension Comment {
    static let storeValue: Self = "A cache should be able to store a value by key"
    static let missingValue: Self = "A cache does not return a value for a missing key"
    static let retrieveValue: Self = "A cache should provide a value by key"
    static let clearValues: Self = "A cache should be able to clear all stored values"

    static let cacheBug: Self = "Test disabled due to URLCache bug: items not cleared"
}

// MARK: - Test Values

fileprivate extension URL {
    static let sampleKey = URL(string: "https://sample.com/something")!
    static let missingKey = URL(string: "https://not.here.com/nothing")!
}

fileprivate extension Data {
    static let sampleValue = Data("this is a sample string for data".utf8)
}

fileprivate extension URLResponse {
    static let sample = URLResponse(
        url: .sampleKey,
        mimeType: nil,
        expectedContentLength: Data.sampleValue.count,
        textEncodingName: nil
    )
//    static let missing = URLResponse(
//        url: .missingKey,
//        mimeType: nil,
//        expectedContentLength: 0,
//        textEncodingName: nil
//    )
}


//
//// MARK: - Test Types
//
//private final class TestURLCache: URLCache {
//
//}
