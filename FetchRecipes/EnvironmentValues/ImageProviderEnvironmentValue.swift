import Foundation
import Model
import Providers
import SwiftUI

extension EnvironmentValues {
    /// An environment value for injecting an image provider to a view hierarchy.
    @Entry var imageProvider: any (ImageProvider & Sendable) = EmptyImageProvider()
}

private actor EmptyImageProvider: ImageProvider {
    func loadImage(at url: URL) async throws -> Data { Data() }

    func deleteAllImages() async {}
}
