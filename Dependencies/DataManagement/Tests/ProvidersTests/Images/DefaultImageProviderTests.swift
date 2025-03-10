import CachingInterface
import Foundation
import NetworkingInterface
import Providers
import Testing

struct DefaultImageProviderTests: Sendable {
    let cache = TestRemoteDataCache()
    let fetcher = TestFetcher()
    let provider: ImageProvider

    init() {
        provider = DefaultImageProvider(fetcher: fetcher, cache: cache)
    }

    @Test func cached() async throws {
        await cache.store(.sample, for: .sample)
        let value = try #require(await provider.loadImage(at: .sample), .providesCachedValue)
        #expect(value == .sample, .providesCachedValue)
        #expect(await fetcher.fetchedURLs.isEmpty, .providesCachedValue)
    }

    @Test func existingTask() async throws {
        await fetcher.setStubbedValues(stubbedFetchData: .sample)
        await fetcher.setIsSuspended(true)
        async let firstResult = provider.loadImage(at: .sample)
        try await Task.sleep(nanoseconds: 1_000_000) // 1 millisecond
        async let secondResult = try await provider.loadImage(at: .sample)
        try await Task.sleep(nanoseconds: 1_000_000) // 1 millisecond
        #expect(await fetcher.fetchedURLs == [.sample], .awaitsExistingTask)
        await fetcher.setIsSuspended(false)
        #expect(try await secondResult == firstResult, .awaitsExistingTask)
    }

    @Test func errors() async throws {
        let expectedError = TestError()
        await fetcher.setStubbedValues(stubbedFetchError: .system(expectedError))
        try await #require {
            _ = try await provider.loadImage(at: .sample)
        }
        throws: { error in
            switch error as? NetworkingError {
            case .system(let wrappedError):
                (wrappedError as? TestError) == expectedError
            default:
                false
            }
        }
    }

    @Test func storing() async throws {
        await fetcher.setStubbedValues(stubbedFetchData: .sample)
        _ = try await provider.loadImage(at: .sample)
        let data = try #require(await cache.value(for: .sample), .storesImage)
        #expect(data == .sample, .storesImage)
    }

    @Test func clearingTasks() async throws {
        await fetcher.setStubbedValues(stubbedFetchData: .sample)
        _ = try await provider.loadImage(at: .sample)
        try await Task.sleep(nanoseconds: 1_000_000) // 1 millisecond
        await cache.clear()
        await fetcher.setStubbedValues(stubbedFetchData: .extra)
        let secondResult = try #require(try await provider.loadImage(at: .sample))
        #expect(secondResult == .extra, .clearsExistingTasks)
    }

    @Test func clearingImages() async {
        await cache.store(.sample, for: .sample)
        await provider.deleteAllImages()
        #expect(await cache.values.isEmpty, .deletesImages)
    }
}

// MARK: - Assumptions

fileprivate extension Comment {
    static let providesCachedValue: Self = "An image provider provides a cached value"
    static let awaitsExistingTask: Self = "An image provider waits on an in-progress task"
    static let propagatesErrors: Self = "An image provider propagates loading errors"
    static let storesImage: Self = "An image provider stores loaded images"
    static let clearsExistingTasks: Self = "An image provider clears existing tasks once complete"
    static let deletesImages: Self = "An image provider deletes all loaded images"
}

// MARK: - Test Values

fileprivate extension URL {
    static let sample = URL(string: "https://sample.com/something")!
}

fileprivate extension Data {
    static let sample = Data("this is a string that has been fetched".utf8)
    static let extra = Data("this is an extra string to use".utf8)
}
