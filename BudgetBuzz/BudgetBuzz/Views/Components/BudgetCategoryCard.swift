import SwiftUI

struct BudgetCategoryCard: View {
    @EnvironmentObject var dataManager: DataManager
    let category: TransactionCategory
    
    var body: some View {
        VStack(spacing: 12) {
            // Category Header
            HStack {
                Label(category.name, systemImage: category.icon)
                    .font(.headline)
                    .foregroundColor(Color(hex: category.color))
                Spacer()
                Text(categorySpent.formatAsCurrency())
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            
            // Progress Bar
            ProgressView(value: categorySpent, total: category.budget ?? 0)
                .tint(progressColor)
            
            // Details
            HStack {
                Text("Remaining: ")
                    .foregroundColor(.secondary)
                Text("\(remainingAmount.formatAsCurrency())")
                    .foregroundColor(remainingAmount >= 0 ? .green : .red)
                Spacer()
                Text("\(Int(percentage))%")
                    .foregroundColor(.secondary)
            }
            .font(.caption)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
    
    private var categorySpent: Double {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        
        return dataManager.transactions
            .filter { transaction in
                let components = Calendar.current.dateComponents([.year, .month], from: transaction.date)
                return components.month == currentMonth &&
                       components.year == currentYear &&
                       transaction.category.id == category.id &&
                       transaction.type == .expense
            }
            .reduce(0) { $0 + $1.amount }
    }
    
    private var remainingAmount: Double {
        (category.budget ?? 0) - categorySpent
    }
    
    private var percentage: Double {
        guard let budget = category.budget, budget > 0 else { return 0 }
        return (categorySpent / budget) * 100
    }
    
    private var progressColor: Color {
        let percentage = categorySpent / (category.budget ?? 1)
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