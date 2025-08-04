import SwiftUI

struct CategoryColorPicker: View {
    @Binding var selectedColor: String
    
    private let colors = [
        "#FF6B6B", "#4ECDC4", "#45B7D1", "#96CEB4", "#D4A5A5",
        "#FFE66D", "#2ECC71", "#3498DB", "#9B59B6", "#E74C3C",
        "#F1C40F", "#1ABC9C", "#34495E", "#E67E22", "#7F8C8D"
    ]
    
    var body: some View {
        NavigationLink {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 20) {
                ForEach(colors, id: \.self) { color in
                    Circle()
                        .fill(Color(hex: color))
                        .frame(width: 44, height: 44)
                        .overlay {
                            if color == selectedColor {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                            }
                        }
                        .onTapGesture {
                            selectedColor = color
                        }
                }
            }
            .padding()
            .navigationTitle("Select Color")
        } label: {
            HStack {
                Text("Color")
                Spacer()
                Circle()
                    .fill(Color(hex: selectedColor))
                    .frame(width: 24, height: 24)
            }
        }
    }
} 