import Foundation

public struct FinancialProfile {
    public let id: UUID
    public let currentIncome: Double
    public let currentSavings: Double
    public let monthlyExpenses: Double
    public let financialGoals: [FinancialGoal]
    public let riskTolerance: RiskTolerance
    public let investmentPreferences: [InvestmentType]
    
    public enum RiskTolerance: String, CaseIterable {
        case conservative
        case moderate
        case aggressive
    }
    
    public enum InvestmentType: String, CaseIterable {
        case stocks
        case bonds
        case mutualFunds
        case realEstate
        case crypto
    }
}

public struct FinancialGoal: Identifiable {
    public let id: UUID
    public let name: String
    public let targetAmount: Double
    public let targetDate: Date
    public let priority: Priority
    public let progress: Double
    
    public enum Priority: String, CaseIterable {
        case high
        case medium
        case low
    }
} 