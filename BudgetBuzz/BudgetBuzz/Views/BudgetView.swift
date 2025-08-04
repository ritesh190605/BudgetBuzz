import SwiftUI

struct BudgetView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddBudget = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Monthly Budget Overview
                    BudgetOverviewCard()
                        .padding(.horizontal)
                    
                    // Category Budgets
                    LazyVStack(spacing: 16) {
                        ForEach(dataManager.categories.filter { $0.budget != nil }) { category in
                            BudgetCategoryCard(category: category)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Budget")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddBudget = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showingAddBudget) {
                BudgetSetupSheet()
            }
        }
    }
}

#Preview {
    BudgetView()
        .environmentObject(DataManager())
} 