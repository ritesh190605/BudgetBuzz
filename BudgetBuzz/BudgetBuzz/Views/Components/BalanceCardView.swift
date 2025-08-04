import SwiftUI

struct BalanceCardView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Total Balance")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(dataManager.totalBalance.formatAsCurrency())
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(dataManager.totalBalance >= 0 ? .green : .red)
            
            HStack(spacing: 24) {
                StatView(title: "Income", 
                        amount: totalIncome,
                        color: .green)
                
                StatView(title: "Expenses", 
                        amount: totalExpenses,
                        color: .red)
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(radius: 5)
    }
    
    private var totalIncome: Double {
        dataManager.transactions
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }
    
    private var totalExpenses: Double {
        dataManager.transactions
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }
}

private struct StatView: View {
    let title: String
    let amount: Double
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(amount.formatAsCurrency())
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
        }
    }
} 