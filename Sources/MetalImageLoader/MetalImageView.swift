import Metal
import MetalKit

public class MetalImageView: MTKView {
    public var renderer: MetalRenderer!
    public var texture: MTLTexture?

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect, device: MTLDevice?) {
        super.init(frame: frame, device: device)
        self.device = MTLCreateSystemDefaultDevice()
        self.renderer = MetalRenderer()
        self.delegate = self
        self.framebufferOnly = false
    }

    public func updateTexture(with image: UIImage) {
        ImageLoader.shared.loadTexture(for: image, device: renderer.device) { [weak self] texture in
            guard let self = self, let texture = texture else { return }
            self.texture = texture
            self.setNeedsDisplay()
        }
    }
}

extension MetalImageView: MTKViewDelegate {
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    public func draw(in view: MTKView) {
        guard let drawable = currentDrawable,
              let descriptor = currentRenderPassDescriptor,
              let texture = texture else { return }

        let commandBuffer = renderer.commandQueue.makeCommandBuffer()!
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)!

        commandEncoder.setRenderPipelineState(renderer.pipelineState)
        commandEncoder.setVertexBuffer(renderer.vertexBuffer, offset: 0, index: 0)
        commandEncoder.setFragmentTexture(texture, index: 0)
        commandEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
        commandEncoder.endEncoding()

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
