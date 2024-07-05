import SwiftUI
import UIKit
public struct MetalImageCollectionView: UIViewRepresentable {
    public var images: [UIImage]

    public init(images: [UIImage]) {
        self.images = images
    }

    public class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
        var parent: MetalImageCollectionView

        init(parent: MetalImageCollectionView) {
            self.parent = parent
        }

        public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return parent.images.count
        }

        public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MetalImageCell", for: indexPath) as! MetalImageCollectionViewCell
            cell.configure(with: parent.images[indexPath.row])
            return cell
        }

        public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let image = parent.images[indexPath.row]
            return CGSize(width: image.size.width, height: image.size.height)
        }

        public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
            for indexPath in indexPaths {
                let image = parent.images[indexPath.row]
                ImageLoader.shared.loadTexture(for: image, device: MTLCreateSystemDefaultDevice() as! MTLDevice, completion: { _ in })
            }
        }
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    public func makeUIView(context: Context) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MetalImageCollectionViewCell.self, forCellWithReuseIdentifier: "MetalImageCell")
        collectionView.dataSource = context.coordinator
        collectionView.delegate = context.coordinator
        collectionView.prefetchDataSource = context.coordinator
        return collectionView
    }

    public func updateUIView(_ uiView: UICollectionView, context: Context) {
        uiView.reloadData()
    }
}
