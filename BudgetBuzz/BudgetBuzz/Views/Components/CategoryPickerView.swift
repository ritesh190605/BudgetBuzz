import SwiftUI

struct CategoryPickerView: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var selectedCategory: TransactionCategory?
    
    var body: some View {
        List(dataManager.categories) { category in
            HStack {
                Label(category.name, systemImage: category.icon)
                Spacer()
                if selectedCategory?.id == category.id {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                selectedCategory = category
            }
        }
        .navigationTitle("Select Category")
    }
} 