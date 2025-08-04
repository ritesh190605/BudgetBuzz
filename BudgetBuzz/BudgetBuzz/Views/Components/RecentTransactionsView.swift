import SwiftUI

struct RecentTransactionsView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Transactions")
                .font(.headline)
            
            if dataManager.transactions.isEmpty {
                EmptyTransactionView()
            } else {
                ForEach(recentTransactions) { transaction in
                    TransactionRowView(transaction: transaction)
                }
                
                if dataManager.transactions.count > 5 {
                    NavigationLink(destination: TransactionListView()) {
                        Text("View All")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
    
    private var recentTransactions: [Transaction] {
        Array(dataManager.transactions.prefix(5))
    }
}

struct TransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            // Category Icon
            Image(systemName: transaction.category.icon)
                .font(.title2)
                .foregroundColor(Color(hex: transaction.category.color))
                .frame(width: 44, height: 44)
                .background(Color(hex: transaction.category.color).opacity(0.2))
                .clipShape(Circle())
            
            // Transaction Details
            VStack(alignment: .leading) {
                Text(transaction.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(transaction.category.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Amount
            Text(formatAmount(transaction.amount, type: transaction.type))
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(transaction.type == .income ? .green : .red)
        }
        .padding(.vertical, 8)
    }
    
    private func formatAmount(_ amount: Double, type: TransactionType) -> String {
        let prefix = type == .income ? "+" : "-"
        return "\(prefix)$\(String(format: "%.2f", amount))"
    }
}

struct EmptyTransactionView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "list.bullet.rectangle.portrait")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            Text("No transactions yet")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
    }
} 