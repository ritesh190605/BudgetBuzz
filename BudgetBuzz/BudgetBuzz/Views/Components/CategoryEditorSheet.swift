import SwiftUI
import BudgetBuzz

struct CategoryEditorSheet: View {
    enum Mode {
        case add
        case edit(TransactionCategory)
    }
    
    let mode: Mode
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var dataManager: DataManager
    @State private var name = ""
    @State private var icon = ""
    @State private var color = "#000000"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Category Details")) {
                    TextField("Name", text: $name)
                    TextField("Icon (SF Symbol)", text: $icon)
                    ColorPicker("Color", selection: .init(
                        get: { Color(hex: color) ?? .black },
                        set: { color = $0.toHex() ?? "#000000" }
                    ))
                }
            }
            .navigationTitle(mode == .add ? "Add Category" : "Edit Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveCategory()
                    }
                }
            }
            .onAppear {
                if case .edit(let category) = mode {
                    name = category.name
                    icon = category.icon
                    color = category.color
                }
            }
        }
    }
    
    private func saveCategory() {
        guard !name.isEmpty, !icon.isEmpty else { return }
        
        let category = TransactionCategory(
            name: name,
            icon: icon,
            color: color
        )
        
        switch mode {
        case .add:
            dataManager.saveCategory(category)
        case .edit(let oldCategory):
            dataManager.updateCategory(category)
        }
        
        dismiss()
    }
}

// Helper extension for Color
extension Color {
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
    
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }
        
        self.init(
            .sRGB,
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0,
            opacity: 1.0
        )
    }
} 