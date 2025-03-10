import Foundation
import NetworkingInterface

/// Interface for fetching data from a remote resource by URL.
actor DebuggingFetcher: RemoteResourceFetching {
    enum Source {
        case data(Data)
        case fetcher(any (RemoteResourceFetching & Sendable))
    }

    private let source: Source

    init(source: Source) {
        self.source = source
    }

    func fetch(from url: URL) async throws(NetworkingError) -> Data {
        do {
            try await Task.sleep(nanoseconds: 3_000_000_000)
        }
        catch {
            throw .system(error)
        }

        switch source {
        case .data(let data):
            return data
        case .fetcher(let fetcher):
            return try await fetcher.fetch(from: url)
        }
    }
}
