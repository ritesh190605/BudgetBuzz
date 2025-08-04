import SwiftUI
import BudgetBuzz

struct CategoryManagementView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddCategory = false
    @State private var editingCategory: TransactionCategory?
    
    var body: some View {
        List {
            ForEach(dataManager.categories) { category in
                CategoryRow(category: category)
                    .contextMenu {
                        Button {
                            editingCategory = category
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        
                        if category.name != "Income" {
                            Button(role: .destructive) {
                                deleteCategory(category)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
            }
        }
        .navigationTitle("Categories")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddCategory = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddCategory) {
            CategoryEditorSheet(mode: .add)
        }
        .sheet(item: $editingCategory) { category in
            CategoryEditorSheet(mode: .edit(category))
        }
    }
    
    private func deleteCategory(_ category: TransactionCategory) {
        dataManager.deleteCategory(category)
    }
}

struct CategoryRow: View {
    let category: TransactionCategory
    
    var body: some View {
        HStack {
            Image(systemName: category.icon)
                .foregroundColor(Color(hex: category.color))
                .frame(width: 30)
            
            Text(category.name)
            
            Spacer()
        }
    }
} 