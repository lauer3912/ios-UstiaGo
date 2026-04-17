import SwiftUI

// MARK: - Theme

enum UstiaTheme {
    // Backgrounds - Apple Design inspired
    static let bgPrimary = Color(hex: "#1D1D1F")
    static let bgSecondary = Color(hex: "#2C2C2E")
    static let surface = Color(hex: "#3A3A3C")
    static let bgElevated = Color(hex: "#48484A")
    
    // Accents - Apple Focus Colors
    static let accentPrimary = Color(hex: "#7C6AFF")
    static let accentSecondary = Color(hex: "#5EEAD4")
    static let accentWarm = Color(hex: "#F59E0B")
    
    // Text - Apple text colors
    static let textPrimary = Color(hex: "#F5F5F7")
    static let textSecondary = Color(hex: "#98989D")
    static let textTertiary = Color(hex: "#636366")
    
    // Borders & Dividers
    static let border = Color(hex: "#3A3A3C")
    
    // Semantic - Apple semantic colors
    static let success = Color(hex: "#30D158")
    static let destructive = Color(hex: "#FF453A")
    static let warning = Color(hex: "#FFD60A")
    static let info = Color(hex: "#64D2FF")
    
    // Gradient - Apple-style gradients
    static let gradientPrimary = LinearGradient(
        colors: [Color(hex: "#7C6AFF"), Color(hex: "#5EEAD4")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientWarm = LinearGradient(
        colors: [Color(hex: "#F59E0B"), Color(hex: "#FF9F0A")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientFocus = LinearGradient(
        colors: [Color(hex: "#BF5AF2"), Color(hex: "#FF375F")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Apple Design Spacing

enum ClaritySpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 20
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let xxxl: CGFloat = 40
}

// MARK: - Apple Design Radius

enum ClarityRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let xlarge: CGFloat = 20
    static let pill: CGFloat = 980
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

// MARK: - Font Extensions - Apple SF Pro

extension Font {
    // Apple-style typography scale
    static let clarityLargeTitle = Font.system(size: 34, weight: .bold, design: .default)
    static let clarityTitle1 = Font.system(size: 28, weight: .bold, design: .default)
    static let clarityTitle2 = Font.system(size: 22, weight: .bold, design: .default)
    static let clarityTitle3 = Font.system(size: 20, weight: .semibold, design: .default)
    static let clarityHeadline = Font.system(size: 17, weight: .semibold, design: .default)
    static let claritySubheadline = Font.system(size: 15, weight: .medium, design: .default)
    static let clarityBody = Font.system(size: 17, weight: .regular, design: .default)
    static let clarityCallout = Font.system(size: 16, weight: .regular, design: .default)
    static let clarityFootnote = Font.system(size: 13, weight: .regular, design: .default)
    static let clarityCaption1 = Font.system(size: 12, weight: .regular, design: .default)
    static let clarityCaption2 = Font.system(size: 11, weight: .regular, design: .default)
    
    // Legacy names for compatibility
    static let clarityCaption = clarityCaption1
    static let clarityTitle = clarityTitle1
    static let clarityMono = Font.system(size: 48, weight: .light, design: .monospaced)
    static let clarityMonoSmall = Font.system(size: 14, weight: .regular, design: .monospaced)
}

// MARK: - View Modifiers - Apple Style

struct ClarityCard: ViewModifier {
    var padding: CGFloat = ClaritySpacing.lg
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(UstiaTheme.bgSecondary)
            .cornerRadius(ClarityRadius.xlarge)
    }
}

struct ClarityButton: ViewModifier {
    var isPrimary: Bool = true
    
    func body(content: Content) -> some View {
        content
            .font(.claritySubheadline)
            .foregroundColor(isPrimary ? .white : UstiaTheme.accentPrimary)
            .padding(.horizontal, ClaritySpacing.xl)
            .padding(.vertical, ClaritySpacing.sm)
            .background(isPrimary ? UstiaTheme.accentPrimary : UstiaTheme.surface)
            .cornerRadius(ClarityRadius.medium)
    }
}

struct ClarityPill: ViewModifier {
    var color: Color = UstiaTheme.accentPrimary
    
    func body(content: Content) -> some View {
        content
            .font(.clarityCaption1)
            .foregroundColor(color)
            .padding(.horizontal, ClaritySpacing.xs)
            .padding(.vertical, ClaritySpacing.xxs)
            .background(color.opacity(0.2))
            .cornerRadius(ClarityRadius.pill)
    }
}

extension View {
    func clarityCard(padding: CGFloat = ClaritySpacing.lg) -> some View {
        modifier(ClarityCard(padding: padding))
    }
    
    func clarityButton(isPrimary: Bool = true) -> some View {
        modifier(ClarityButton(isPrimary: isPrimary))
    }
    
    func clarityPill(color: Color = UstiaTheme.accentPrimary) -> some View {
        modifier(ClarityPill(color: color))
    }
}
