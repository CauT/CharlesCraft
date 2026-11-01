import AppKit
import Foundation

let directory = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true)
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
for obsolete in ["icon_64x64.png", "icon_64x64@2x.png"] {
    try? FileManager.default.removeItem(at: directory.appendingPathComponent(obsolete))
}
for size in [16, 32, 64, 128, 256, 512, 1024] {
    let image = NSImage(size: NSSize(width: size, height: size))
    image.lockFocus()
    let scale = CGFloat(size) / 1024
    let transform = NSAffineTransform(); transform.scale(by: scale); transform.concat()
    let rect = NSRect(x: 58, y: 58, width: 908, height: 908)
    let shape = NSBezierPath(roundedRect: rect, xRadius: 202, yRadius: 202)
    NSGradient(starting: NSColor(srgbRed: 0.08, green: 0.17, blue: 0.25, alpha: 1), ending: NSColor(srgbRed: 0.03, green: 0.43, blue: 0.49, alpha: 1))!.draw(in: shape, angle: -55)
    let circuit = NSBezierPath()
    circuit.move(to: NSPoint(x: 730, y: 716))
    circuit.line(to: NSPoint(x: 410, y: 716))
    circuit.curve(to: NSPoint(x: 260, y: 566), controlPoint1: NSPoint(x: 320, y: 716), controlPoint2: NSPoint(x: 260, y: 656))
    circuit.line(to: NSPoint(x: 260, y: 458))
    circuit.curve(to: NSPoint(x: 410, y: 308), controlPoint1: NSPoint(x: 260, y: 368), controlPoint2: NSPoint(x: 320, y: 308))
    circuit.line(to: NSPoint(x: 730, y: 308))
    circuit.lineWidth = 70; circuit.lineCapStyle = .round
    NSColor.white.setStroke(); circuit.stroke()
    let exchange = NSBezierPath()
    exchange.move(to: NSPoint(x: 455, y: 512)); exchange.line(to: NSPoint(x: 725, y: 512))
    exchange.lineWidth = 58; exchange.lineCapStyle = .round
    NSColor(srgbRed: 0.27, green: 0.91, blue: 0.85, alpha: 1).setStroke(); exchange.stroke()
    for point in [NSPoint(x: 730, y: 716), NSPoint(x: 730, y: 308)] {
        NSColor(srgbRed: 0.27, green: 0.91, blue: 0.85, alpha: 1).setFill()
        NSBezierPath(ovalIn: NSRect(x: point.x - 53, y: point.y - 53, width: 106, height: 106)).fill()
    }
    image.unlockFocus()
    let representation = NSBitmapImageRep(data: image.tiffRepresentation!)!
    let data = representation.representation(using: .png, properties: [:])!
    let filename: String
    if size == 1024 { filename = "icon_512x512@2x.png" }
    else { filename = "icon_\(size)x\(size).png" }
    if size != 64 { try data.write(to: directory.appendingPathComponent(filename)) }
    if size >= 32 && size <= 512 && size != 128 {
        try data.write(to: directory.appendingPathComponent("icon_\(size / 2)x\(size / 2)@2x.png"))
    }
}
