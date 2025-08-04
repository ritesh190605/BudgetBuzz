import Foundation

extension NumberFormatter {
    static var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        // Get the currency symbol from UserDefaults or use default
        if let symbol = UserDefaults.standard.string(forKey: "currencySymbol") {
            formatter.currencySymbol = symbol
        } else {
            formatter.currencySymbol = "₹" // Default to Indian Rupee
        }
        
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

extension Double {
    func formatAsCurrency() -> String {
        return NumberFormatter.currencyFormatter.string(from: NSNumber(value: self)) ?? "₹0.00"
    }
} 