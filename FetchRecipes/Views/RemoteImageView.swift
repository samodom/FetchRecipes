import Model
import SwiftUI

struct RemoteImageView: View {
    let data: Data?

    @ViewBuilder var body: some View {
        if let data {
            imageView(with: data)
        }
        else {
            Image(systemName: "photo")
        }
    }

    @ViewBuilder  func imageView(with data: Data) -> some View {
        if let image = UIImage(data: data) {
            Image(uiImage: image).resizable()
        }
        else {
            Image(systemName: "photo")
        }
    }
}
