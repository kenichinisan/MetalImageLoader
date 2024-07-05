import Metal
import MetalKit

public class MetalRenderer {
    public var device: MTLDevice!
    public var commandQueue: MTLCommandQueue!
    public var pipelineState: MTLRenderPipelineState!
    public var vertexBuffer: MTLBuffer!

    public init() {
        device = MTLCreateSystemDefaultDevice()
        commandQueue = device.makeCommandQueue()
        setupPipeline()
        setupVertexBuffer()
    }

    private func setupPipeline() {
        guard let library = device.makeDefaultLibrary() else {
            fatalError("Could not create default library.")
        }
        
        let vertexFunction = library.makeFunction(name: "vertex_main")
        let fragmentFunction = library.makeFunction(name: "fragment_main")

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm

        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("Could not create render pipeline state: \(error)")
        }
    }

    private func setupVertexBuffer() {
        let vertexData: [Float] = [
            -1.0, -1.0, 0.0, 1.0,
             1.0, -1.0, 0.0, 1.0,
            -1.0,  1.0, 0.0, 1.0,
             1.0,  1.0, 0.0, 1.0,
        ]
        vertexBuffer = device.makeBuffer(bytes: vertexData, length: vertexData.count * MemoryLayout<Float>.size, options: [])
    }
}
