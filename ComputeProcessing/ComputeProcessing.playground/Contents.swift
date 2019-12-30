
import MetalKit
import PlaygroundSupport

let frame = NSRect(x: 0, y: 0, width: 800, height: 1280)
let delegate = Renderer()
let view = MTKView(frame: frame, device: delegate.device)
view.delegate = delegate
PlaygroundPage.current.liveView = view
