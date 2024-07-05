import Metal
import MetalKit

public class ImageLoader {
    public static let shared = ImageLoader()
    private var cache = NSCache<NSString, MTLTexture>()
    private let queue = DispatchQueue(label: "imageLoaderQueue")

    public func loadTexture(for image: UIImage, device: MTLDevice, completion: @escaping (MTLTexture?) -> Void) {
        let key = NSString(string: image.accessibilityIdentifier ?? UUID().uuidString)

        // Check cache
        if let cachedTexture = cache.object(forKey: key) {
            completion(cachedTexture)
            return
        }

        // Load image asynchronously
        queue.async {
            guard let texture = self.createTexture(from: image, device: device) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            self.cache.setObject(texture, forKey: key)
            DispatchQueue.main.async { completion(texture) }
        }
    }

    private func createTexture(from image: UIImage, device: MTLDevice) -> MTLTexture? {
        guard let cgImage = image.cgImage else { return nil }
        let textureLoader = MTKTextureLoader(device: device)
        let options: [MTKTextureLoader.Option: Any] = [.SRGB: false]
        return try? textureLoader.newTexture(cgImage: cgImage, options: options)
    }
}
