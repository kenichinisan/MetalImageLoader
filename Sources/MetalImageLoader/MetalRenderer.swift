import Metal
import MetalKit
import UIKit

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
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertex_main")
        let fragmentFunction = library?.makeFunction(name: "fragment_main")

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm

        pipelineState = try? device.makeRenderPipelineState(descriptor: pipelineDescriptor)
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
