import Foundation
import SwiftUI

@MainActor
public class FinancialDashboardViewModel: ObservableObject {
    @Published public var userName: String = "John Doe"
    @Published public var currentNetWorth: Double = 50000.0
    @Published public var monthlyIncome: Double = 7500.0
    @Published public var monthlyExpenses: Double = 4500.0
    @Published public var transactions: [Transaction] = []
    @Published public var goals: [FinancialGoal] = []
    @Published public var profile: FinancialProfile
    
    public init() {
        // Initialize with default values
        self.profile = FinancialProfile(
            id: UUID(),
            currentIncome: 7500.0,
            currentSavings: 50000.0,
            monthlyExpenses: 4500.0,
            financialGoals: [],
            riskTolerance: .moderate,
            investmentPreferences: [.stocks, .mutualFunds]
        )
        
        // Load initial data
        loadInitialData()
    }
    
    private func loadInitialData() {
        // Simulate loading data
        transactions = [
            Transaction(
                amount: 7500.0,
                category: TransactionCategory(name: "Salary", icon: "dollarsign.circle", color: "#4CAF50"),
                description: "Monthly Salary",
                type: .income
            ),
            Transaction(
                amount: -2000.0,
                category: TransactionCategory(name: "Rent", icon: "house", color: "#2196F3"),
                description: "Monthly Rent",
                type: .expense
            ),
            Transaction(
                amount: -500.0,
                category: TransactionCategory(name: "Utilities", icon: "bolt", color: "#FFC107"),
                description: "Electricity Bill",
                type: .expense
            )
        ]
        
        goals = [
            FinancialGoal(
                id: UUID(),
                name: "Emergency Fund",
                targetAmount: 30000.0,
                targetDate: Calendar.current.date(byAdding: .year, value: 1, to: Date())!,
                priority: .high,
                progress: 0.5
            ),
            FinancialGoal(
                id: UUID(),
                name: "New Car",
                targetAmount: 25000.0,
                targetDate: Calendar.current.date(byAdding: .year, value: 2, to: Date())!,
                priority: .medium,
                progress: 0.2
            )
        ]
    }
    
    // MARK: - Public Methods
    
    public func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        updateNetWorth()
    }
    
    public func updateNetWorth() {
        let totalIncome = transactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
        let totalExpenses = abs(transactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount })
        currentNetWorth = totalIncome - totalExpenses
    }
    
    public func updateMonthlyMetrics() {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())
        
        let monthlyTransactions = transactions.filter { transaction in
            let transactionMonth = calendar.component(.month, from: transaction.date)
            let transactionYear = calendar.component(.year, from: transaction.date)
            return transactionMonth == currentMonth && transactionYear == currentYear
        }
        
        monthlyIncome = monthlyTransactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
        monthlyExpenses = abs(monthlyTransactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount })
    }
} 