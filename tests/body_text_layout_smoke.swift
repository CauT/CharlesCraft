import AppKit
import Foundation
import SwiftUI

private struct LayoutFailure: Error { let message: String }

@main struct BodyTextLayoutSmoke {
    @MainActor static func main() throws {
        _ = NSApplication.shared
        let scroll = LensBodyScrollView(frame: NSRect(x: 0, y: 0, width: 440, height: 260))
        let text = NSTextView(frame: scroll.contentView.bounds)
        text.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        text.isVerticallyResizable = true
        text.isHorizontallyResizable = false
        text.autoresizingMask = [.width]
        text.textContainerInset = NSSize(width: 0, height: 6)
        text.textContainer?.widthTracksTextView = true
        text.textContainer?.containerSize = NSSize(width: 440, height: CGFloat.greatestFiniteMagnitude)
        text.string = "{\n  \"message\": \"" + String(repeating: "Every visible character must fit. ", count: 30) + "\"\n}"
        scroll.documentView = text
        let ruler = NSRulerView(scrollView: scroll, orientation: .verticalRuler)
        ruler.ruleThickness = 48
        scroll.verticalRulerView = ruler
        scroll.hasVerticalRuler = true
        scroll.rulersVisible = true
        scroll.hasVerticalScroller = true
        for width in [440.0, 290.0, 570.0] {
            scroll.setFrameSize(NSSize(width: width, height: 260))
            scroll.tile()
            guard let layout = text.layoutManager, let container = text.textContainer else {
                throw LayoutFailure(message: "TextKit owner is missing")
            }
            layout.ensureLayout(for: container)
            let used = layout.usedRect(for: container)
            let viewport = scroll.contentView.bounds.width
            guard used.maxX <= viewport + 0.5, text.frame.width <= viewport + 0.5 else {
                throw LayoutFailure(message: "Wrapped text is clipped after ruler/viewport resize: \(used.maxX) > \(viewport)")
            }
            guard layout.numberOfGlyphs == (text.string as NSString).length else {
                throw LayoutFailure(message: "Layout omitted captured text")
            }
        }
        // SwiftUI's hosted ruler overlays the clip view and moves its bounds
        // origin left. A bare NSScrollView does not reproduce that geometry.
        let host = NSHostingView(rootView: ScrollView {
            VStack(alignment: .leading) {
                Text("Body")
                LensBodyTextView(text: text.string, title: "Hosted", lineNumbers: true).frame(height: 460)
            }.padding(14)
        })
        for width in [494.0, 350.0, 700.0] {
            host.frame = NSRect(x: 0, y: 0, width: width, height: 600)
            for _ in 0..<5 {
                host.layoutSubtreeIfNeeded()
                RunLoop.current.run(until: Date().addingTimeInterval(0.01))
            }
            func findBody(_ view: NSView) -> LensBodyScrollView? {
                if let body = view as? LensBodyScrollView { return body }
                return view.subviews.lazy.compactMap { findBody($0) }.first
            }
            guard let body = findBody(host), let hostedText = body.documentView as? NSTextView,
                  let layout = hostedText.layoutManager, let container = hostedText.textContainer else {
                throw LayoutFailure(message: "Hosted body did not materialize")
            }
            layout.ensureLayout(for: container)
            // Compare actual glyphs in clip coordinates, rather than comparing
            // two widths that can agree while the ruler obscures their edge.
            let used = body.contentView.convert(layout.usedRect(for: container).offsetBy(
                dx: hostedText.textContainerOrigin.x, dy: hostedText.textContainerOrigin.y), from: hostedText)
            guard used.maxX <= body.contentView.bounds.maxX + 0.5 else {
                throw LayoutFailure(message: "Hosted glyph edge \(used.maxX) exceeds visible edge \(body.contentView.bounds.maxX), bounds \(body.contentView.bounds)")
            }
        }
        print("PASS: wrapped body glyphs fit the actual viewport with a ruler and after narrow/wide resize")
    }
}
