import AppKit
import SwiftUI

/// Presentation tokens only. Persisted Lens identifiers and capture protocols
/// deliberately live outside the product's display-name boundary.
enum CraftDesign {
    static let productName = "CharlesCraft"
    static let accent = Color(red: 0.03, green: 0.52, blue: 0.58)
    static let ink = adaptive(light: NSColor(srgbRed: 0.10, green: 0.17, blue: 0.25, alpha: 1), dark: .labelColor)
    static let canvas = adaptive(light: NSColor(srgbRed: 0.95, green: 0.97, blue: 0.98, alpha: 1), dark: .windowBackgroundColor)
    static let surface = adaptive(light: .white, dark: .controlBackgroundColor)
    static let sidebar = adaptive(light: NSColor(srgbRed: 0.93, green: 0.96, blue: 0.97, alpha: 1), dark: .underPageBackgroundColor)
    static let line = Color.primary.opacity(0.09)

    private static func adaptive(light: NSColor, dark: NSColor) -> Color {
        Color(nsColor: NSColor(name: nil) { appearance in
            appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? dark : light
        })
    }
}

struct CraftMark: View {
    var size: CGFloat = 34
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.26)
                .fill(LinearGradient(colors: [CraftDesign.ink, CraftDesign.accent], startPoint: .topLeading, endPoint: .bottomTrailing))
            Image(systemName: "point.3.connected.trianglepath.dotted")
                .font(.system(size: size * 0.54, weight: .semibold)).foregroundStyle(.white)
        }.frame(width: size, height: size).accessibilityHidden(true)
    }
}

struct CraftPanelHeading: View {
    let title: String
    let subtitle: String
    let icon: String
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: icon).font(.system(size: 19, weight: .medium))
                .foregroundStyle(CraftDesign.accent).frame(width: 44, height: 44)
                .background(CraftDesign.accent.opacity(0.10), in: RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.system(size: 22, weight: .semibold)).foregroundStyle(CraftDesign.ink)
                Text(subtitle).font(.callout).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }.padding(.bottom, 4)
    }
}

struct CraftBadge: View {
    let text: String
    var color: Color = CraftDesign.accent
    var isSelected = false
    var body: some View {
        Group {
            // Inherit the native table's foreground for active and inactive
            // selection instead of painting a semantic color over its highlight.
            if isSelected { Text(text) }
            else { Text(text).foregroundStyle(color) }
        }
        .font(.system(size: 10, weight: .semibold, design: .monospaced))
        .padding(.horizontal, 7).padding(.vertical, 4)
        .background(isSelected ? Color.clear : color.opacity(0.10), in: RoundedRectangle(cornerRadius: 5))
    }
}

struct CraftCardModifier: ViewModifier {
    var padding: CGFloat = 14
    func body(content: Content) -> some View {
        content.padding(padding)
            .background(CraftDesign.surface, in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(CraftDesign.line))
    }
}

extension View {
    func craftCard(padding: CGFloat = 14) -> some View { modifier(CraftCardModifier(padding: padding)) }
    func craftSheet() -> some View {
        tint(CraftDesign.accent).background(CraftDesign.canvas)
    }
}
