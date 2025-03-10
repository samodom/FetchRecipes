import CachingInterface
import Foundation

actor TestRemoteDataCache: Caching {
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
