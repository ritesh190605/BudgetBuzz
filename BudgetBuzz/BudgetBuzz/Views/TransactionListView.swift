import SwiftUI

struct TransactionListView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var searchText = ""
    @State private var selectedFilter: TransactionType?
    
    var body: some View {
        List {
            // Filter Section
            Section {
                Picker("Filter", selection: $selectedFilter) {
                    Text("All").tag(Optional<TransactionType>.none)
                    Text("Income").tag(Optional(TransactionType.income))
                    Text("Expense").tag(Optional(TransactionType.expense))
                }
                .pickerStyle(.segmented)
            }
            
            // Transactions Section
            Section {
                ForEach(filteredTransactions) { transaction in
                    TransactionRowView(transaction: transaction)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                dataManager.deleteTransaction(transaction)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .navigationTitle("Transactions")
        .searchable(text: $searchText, prompt: "Search transactions")
    }
    
    private var filteredTransactions: [Transaction] {
        var transactions = dataManager.transactions
        
        // Apply search filter
        if !searchText.isEmpty {
            transactions = transactions.filter { transaction in
                transaction.title.localizedCaseInsensitiveContains(searchText) ||
                transaction.category.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply type filter
        if let filter = selectedFilter {
            transactions = transactions.filter { $0.type == filter }
        }
        
        // Sort by date (newest first)
        return transactions.sorted { $0.date > $1.date }
    }
}

#Preview {
    let dataManager = DataManager()
    // Add some sample data for the preview
    dataManager.addTransaction(Transaction(
        amount: 50.0,
        title: "Lunch",
        category: TransactionCategory(name: "Food", icon: "fork.knife", color: "#FF6B6B"),
        type: .expense
    ))
    
    return NavigationView {
        TransactionListView()
            .environmentObject(dataManager)
    }
} 