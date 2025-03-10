import CachingInterface
import Foundation

/// An implementation of the `Caching` interface that stores `Data` values by a `URL` key.
/// The injectable underlying `URLCache` instance can be configured as needed.
public actor DefaultRemoteDataCache: Caching {
    public typealias Key = URL
    public typealias Value = Data

    private let urlCache: URLCache

    /// Creates a cache from any URL-keyed data-storing cache.
    /// - Parameter urlCache: A `Foundation.URLCache` instance that acts as the backing store.
    public init(urlCache: URLCache) {
        self.urlCache = urlCache
    }

    /// Retrieves the value stored in the cache for the provided key if it exists.
    /// - Parameter key: The key used to look up a potentially-stored value.
    /// - Returns: The value associated with the provided key if it exists.
    public func value(for key: Key) -> Value? {
        let request = URLRequest(url: key)
        let response = urlCache.cachedResponse(for: request)
        return response?.data
    }

    /// Stores a value with an associated key.
    /// - Parameter value: The value to store with the provided key.
    /// - Parameter key: The key to associate with the stored value.
    public func store(_ value: Value, for key: Key) {
        let request = URLRequest(url: key)
        let urlResponse = URLResponse(
            url: key,
            mimeType: nil,
            expectedContentLength: value.count,
            textEncodingName: nil
        )
        let cachedResponse = CachedURLResponse(response: urlResponse, data: value)
        urlCache.storeCachedResponse(cachedResponse, for: request)
    }

    /// Removes all items from the cache.
    public func clear() {
        urlCache.removeCachedResponses(since: .distantPast)
    }
}
