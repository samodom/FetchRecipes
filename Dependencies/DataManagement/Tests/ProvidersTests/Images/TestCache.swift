import CachingInterface
import Foundation

final class TestRemoteDataCache: Caching, @unchecked Sendable {
    typealias Key = URL
    typealias Value = Data

    var values = [URL: Data]()

    func value(for key: Key) -> Value? {
        values[key]
    }

    func store(_ item: Value, for key: Key) {
        values[key] = item
    }

    func clear() {
        values = [:]
    }
}
