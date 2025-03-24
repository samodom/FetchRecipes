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

#Preview(traits: .fixedLayout(width: 200, height: 200)) {
    let imageData = UIImage(named: "SwiftEweEye")!.pngData()
    RemoteImageView(data: imageData)
}
