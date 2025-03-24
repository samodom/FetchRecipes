import CachingInterface
import Foundation
import Providers
import UIKit

extension RecipePreviews {
    actor PreviewImageProvider: ImageProvider {
        private let cache = PreviewCache()

        func loadImage(at url: URL) async throws -> Data {
            if let data = await cache.value(for: url) {
                return data
            }

            try await Task.sleep(for: .seconds(1))

            guard let data = UIImage(named: "SwiftEweEye")?.pngData()
            else { fatalError("Could not load preview asset") }

            await cache.store(data, for: url)
            return data
        }

        func deleteAllImages() async {
            await cache.clear()
        }
    }

    private actor PreviewCache: Caching {
        typealias Key = URL
        typealias Value = Data
        private var values = [URL: Data]()

        func value(for key: Key) -> Value? {
            values[key]
        }

        func store(_ value: Value, for key: Key) {
            values[key] = value
        }

        func clear() {
            values = [:]
        }
    }
}
