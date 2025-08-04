import SwiftUI

struct TransactionSummaryCard: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        VStack(spacing: 16) {
            // Current Month
            Text(currentMonth)
                .font(.headline)
                .foregroundColor(.secondary)
            
            // Summary Stats
            HStack(spacing: 24) {
                StatView(
                    title: "Income",
                    amount: monthlyIncome,
                    icon: "arrow.down.circle.fill",
                    color: .green
                )
                
                StatView(
                    title: "Expenses",
                    amount: monthlyExpenses,
                    icon: "arrow.up.circle.fill",
                    color: .red
                )
                
                StatView(
                    title: "Balance",
                    amount: monthlyBalance,
                    icon: "dollarsign.circle.fill",
                    color: monthlyBalance >= 0 ? .blue : .red
                )
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private var currentMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: Date())
    }
    
    private var monthlyIncome: Double {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        
        return dataManager.transactions
            .filter { transaction in
                let components = Calendar.current.dateComponents([.year, .month], from: transaction.date)
                return components.month == currentMonth &&
                       components.year == currentYear &&
                       transaction.type == .income
            }
            .reduce(0) { $0 + $1.amount }
    }
    
    private var monthlyExpenses: Double {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        
        return dataManager.transactions
            .filter { transaction in
                let components = Calendar.current.dateComponents([.year, .month], from: transaction.date)
                return components.month == currentMonth &&
                       components.year == currentYear &&
                       transaction.type == .expense
            }
            .reduce(0) { $0 + $1.amount }
    }
    
    private var monthlyBalance: Double {
        monthlyIncome - monthlyExpenses
    }
}

private struct StatView: View {
    let title: String
    let amount: Double
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(String(format: "$%.2f", amount))
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
    }
}

#Preview {
    TransactionSummaryCard()
        .environmentObject(DataManager())
        .padding()
} 