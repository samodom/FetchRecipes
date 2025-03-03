import Foundation

/// An interface for retrieving, storing and deleting image data.
public protocol ImageProvider: Sendable {
    /// Asynchronously loads data for an image at a specified URL.
    /// - Parameter url: The URL from which to load the image data.
    /// - Returns: The retrieved and stored data if loading is successful.
    /// - Throws: Any error encountered in loading or storing image data.
    func loadImage(at url: URL) async throws -> Data

    /// Removes all images stored in a cache.
    func deleteAllImages() async
}
