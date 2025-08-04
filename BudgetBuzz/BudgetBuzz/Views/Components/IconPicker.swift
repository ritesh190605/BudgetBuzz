import SwiftUI

struct IconPicker: View {
    @Binding var selectedIcon: String
    
    private let icons = [
        "tag", "cart.fill", "fork.knife", "car.fill", "house.fill", "tv.fill",
        "gamecontroller.fill", "tshirt.fill", "cross.case.fill", "dumbbell.fill",
        "airplane", "bus.fill", "train.side.front.car", "bolt.fill",
        "wifi", "phone.fill", "gift.fill", "book.fill", "graduationcap.fill",
        "dollarsign.circle.fill", "creditcard.fill", "bag.fill",
        "cart.circle.fill", "heart.fill", "star.fill", "music.note",
        "sportscourt.fill", "film.fill", "theatermasks.fill"
    ]
    
    var body: some View {
        NavigationLink {
            List(icons, id: \.self) { icon in
                HStack {
                    Image(systemName: icon)
                        .frame(width: 30)
                    Text(icon.replacingOccurrences(of: ".fill", with: "")
                        .replacingOccurrences(of: ".", with: " ")
                        .capitalized)
                    Spacer()
                    if icon == selectedIcon {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedIcon = icon
                }
            }
            .navigationTitle("Select Icon")
        } label: {
            HStack {
                Text("Icon")
                Spacer()
                Image(systemName: selectedIcon)
                    .foregroundColor(.blue)
            }
        }
    }
} 