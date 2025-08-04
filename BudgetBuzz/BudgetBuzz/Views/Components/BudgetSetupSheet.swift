import SwiftUI

struct BudgetSetupSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationView {
            List {
                ForEach(dataManager.categories) { category in
                    BudgetCategoryRow(category: category)
                }
            }
            .navigationTitle("Set Budgets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct BudgetCategoryRow: View {
    @EnvironmentObject var dataManager: DataManager
    let category: TransactionCategory
    @State private var budgetAmount: String
    
    init(category: TransactionCategory) {
        self.category = category
        let initialValue = category.budget.map { String(format: "%.2f", $0) } ?? ""
        _budgetAmount = State(initialValue: initialValue)
    }
    
    var body: some View {
        HStack {
            Label(category.name, systemImage: category.icon)
                .foregroundColor(Color(hex: category.color))
            Spacer()
            TextField("Budget", text: $budgetAmount)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 100)
                .onChange(of: budgetAmount) { _, newValue in
                    if let amount = Double(newValue) {
                        var updatedCategory = category
                        updatedCategory.budget = amount
                        dataManager.updateCategory(updatedCategory)
                    }
                }
        }
    }
}

#Preview {
    BudgetSetupSheet()
        .environmentObject(DataManager())
} 