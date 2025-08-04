import SwiftUI

struct BudgetOverviewCard: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        VStack(spacing: 16) {
            // Title and Month
            HStack {
                Text("Monthly Overview")
                    .font(.headline)
                Spacer()
                Text(currentMonth)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Progress Bar
            VStack(spacing: 8) {
                ProgressView(value: totalSpent, total: totalBudget)
                    .tint(progressColor)
                
                HStack {
                    Text("Spent: $\(String(format: "%.2f", totalSpent))")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("Budget: $\(String(format: "%.2f", totalBudget))")
                        .foregroundColor(.secondary)
                }
                .font(.caption)
            }
            
            // Remaining Amount
            VStack(spacing: 4) {
                Text("Remaining")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("$\(String(format: "%.2f", remainingAmount))")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(remainingAmount >= 0 ? .green : .red)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private var currentMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: Date())
    }
    
    private var totalBudget: Double {
        dataManager.categories
            .compactMap { $0.budget }
            .reduce(0, +)
    }
    
    private var totalSpent: Double {
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
    
    private var remainingAmount: Double {
        totalBudget - totalSpent
    }
    
    private var progressColor: Color {
        let percentage = totalSpent / totalBudget
        switch percentage {
        case ..<0.7:
            return .green
        case 0.7..<0.9:
            return .yellow
        default:
            return .red
        }
    }
} 