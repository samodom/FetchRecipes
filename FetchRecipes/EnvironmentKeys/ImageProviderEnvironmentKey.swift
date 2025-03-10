import Foundation
import Model
import Providers
import SwiftUI

private struct ImageProviderEnvironmentKey: EnvironmentKey {
    static let defaultValue: any (ImageProvider & Sendable) = EmptyImageProvider()
}

extension EnvironmentValues {
    /// An environment value for injecting an image provider to a view hierarchy.
    var imageProvider: any (ImageProvider & Sendable) {
        get { self[ImageProviderEnvironmentKey.self] }
        set { self[ImageProviderEnvironmentKey.self] = newValue }
    }
}

private actor EmptyImageProvider: ImageProvider {
    func loadImage(at url: URL) async throws -> Data { Data() }

    func deleteAllImages() async {}
}
