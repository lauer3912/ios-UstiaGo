import SwiftUI

// MARK: - Theme

enum ClarityTheme {
    // Backgrounds
    static let bgPrimary = Color(hex: "#0F0F13")
    static let bgSecondary = Color(hex: "#1A1A21")
    static let surface = Color(hex: "#24242E")
    
    // Accents
    static let accentPrimary = Color(hex: "#7C6AFF")
    static let accentSecondary = Color(hex: "#5EEAD4")
    static let accentWarm = Color(hex: "#F59E0B")
    
    // Text
    static let textPrimary = Color(hex: "#F4F4F6")
    static let textSecondary = Color(hex: "#8B8B9E")
    static let textTertiary = Color(hex: "#55556A")
    
    // Borders & Dividers
    static let border = Color(hex: "#2E2E3A")
    
    // Semantic
    static let success = Color(hex: "#34D399")
    static let destructive = Color(hex: "#F87171")
    
    // Gradient
    static let gradientPrimary = LinearGradient(
        colors: [Color(hex: "#7C6AFF"), Color(hex: "#5EEAD4")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientWarm = LinearGradient(
        colors: [Color(hex: "#F59E0B"), Color(hex: "#F87171")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    var hexString: String {
        guard let components = UIColor(self).cgColor.components else { return "#000000" }
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}

// MARK: - Font Extensions

extension Font {
    static let clarityTitle = Font.system(size: 28, weight: .bold, design: .rounded)
    static let clarityHeadline = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let claritySubheadline = Font.system(size: 16, weight: .medium, design: .rounded)
    static let clarityBody = Font.system(size: 15, weight: .regular, design: .default)
    static let clarityCaption = Font.system(size: 13, weight: .regular, design: .default)
    static let clarityMono = Font.system(size: 48, weight: .light, design: .monospaced)
    static let clarityMonoSmall = Font.system(size: 14, weight: .regular, design: .monospaced)
}

// MARK: - View Modifiers

struct ClarityCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(ClarityTheme.bgSecondary)
            .cornerRadius(20)
    }
}

struct ClarityButton: ViewModifier {
    var isPrimary: Bool = true
    
    func body(content: Content) -> some View {
        content
            .font(.claritySubheadline)
            .foregroundColor(isPrimary ? .white : ClarityTheme.accentPrimary)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(isPrimary ? ClarityTheme.accentPrimary : ClarityTheme.surface)
            .cornerRadius(14)
    }
}

extension View {
    func clarityCard() -> some View {
        modifier(ClarityCard())
    }
    
    func clarityButton(isPrimary: Bool = true) -> some View {
        modifier(ClarityButton(isPrimary: isPrimary))
    }
}
