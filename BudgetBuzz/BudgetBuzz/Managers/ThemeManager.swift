import SwiftUI

// Colors
public class ThemeManager: ObservableObject {
    public static let shared = ThemeManager()
    
    @Published public var isDarkMode: Bool = false
    
    private init() {}
    
    public struct ThemeColors {
        public static let primary = Color(red: 0.0, green: 0.5, blue: 1.0)
        public static let secondary = Color(red: 0.2, green: 0.6, blue: 1.0)
        public static let background = Color(red: 0.95, green: 0.95, blue: 0.95)
        public static let cardBackground = Color(red: 1.0, green: 1.0, blue: 1.0)
        public static let text = Color(red: 0.1, green: 0.1, blue: 0.1)
        public static let secondaryText = Color(red: 0.4, green: 0.4, blue: 0.4)
        public static let success = Color(red: 0.2, green: 0.8, blue: 0.2)
        public static let error = Color(red: 0.8, green: 0.2, blue: 0.2)
    }
    
    // Gradients
    public struct ThemeGradients {
        public static let primary = LinearGradient(
            colors: [ThemeColors.primary, ThemeColors.secondary],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        public static let secondary = LinearGradient(
            colors: [ThemeColors.secondary, ThemeColors.primary],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // Typography
    public struct ThemeTypography {
        public static let title = Font.system(size: 24, weight: .bold)
        public static let subtitle = Font.system(size: 18, weight: .semibold)
        public static let body = Font.system(size: 16, weight: .regular)
        public static let caption = Font.system(size: 14, weight: .regular)
    }
} 