/// A limited caching interface that is generic over the key and value types.
public protocol Caching {
    /// The type used to represent keys in a cache.
    associatedtype Key: Hashable

    /// The type used to represent storable values in a cache.
    associatedtype Value

    /// Retrieves the value stored in the cache for the provided key if it exists.
    /// - Parameter key: The key used to look up a potentially-stored value.
    /// - Returns: The value associated with the provided key if it exists.
    func value(for key: Key) -> Value?

    /// Stores a value with an associated key.
    /// - Parameter value: The value to store with the provided key.
    /// - Parameter key: The key to associate with the stored value.
    func store(_ value: Value, for key: Key)

    /// Removes all items from the cache.
    func clear()
}
