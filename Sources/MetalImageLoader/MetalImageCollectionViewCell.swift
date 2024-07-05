import UIKit

public class MetalImageCollectionViewCell: UICollectionViewCell {
    public var metalImageView: MetalImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMetalImageView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupMetalImageView()
    }

    private func setupMetalImageView() {
        metalImageView = MetalImageView(frame: contentView.bounds, device: MTLCreateSystemDefaultDevice())
        metalImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(metalImageView)
    }

    public func configure(with image: UIImage) {
        metalImageView.updateTexture(with: image)
    }
}
