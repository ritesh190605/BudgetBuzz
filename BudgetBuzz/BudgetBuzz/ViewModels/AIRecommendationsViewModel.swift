import Foundation
import Combine

public class AIRecommendationsViewModel: ObservableObject {
    @Published public var recommendations: [AIRecommendation] = []
    @Published public var isLoading: Bool = false
    @Published public var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    private let financialViewModel: FinancialDashboardViewModel
    
    public init(financialViewModel: FinancialDashboardViewModel) {
        self.financialViewModel = financialViewModel
        loadRecommendations()
    }
    
    public func loadRecommendations() {
        isLoading = true
        
        // Simulate API call with a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            
            // Generate sample recommendations based on financial data
            self.recommendations = [
                AIRecommendation(
                    title: "Optimize Savings",
                    description: "Based on your current spending patterns, you could save an additional $500 per month by reducing discretionary expenses.",
                    category: .savings,
                    priority: .high,
                    action: "Review Expenses"
                ),
                AIRecommendation(
                    title: "Investment Opportunity",
                    description: "Consider investing in index funds. Your current cash position suggests you could benefit from long-term investments.",
                    category: .investment,
                    priority: .medium,
                    action: "Explore Investments"
                ),
                AIRecommendation(
                    title: "Debt Management",
                    description: "Your credit card utilization is high. Consider consolidating your debt for better interest rates.",
                    category: .debt,
                    priority: .high,
                    action: "View Options"
                )
            ]
            
            self.isLoading = false
        }
    }
    
    public func refreshRecommendations() {
        loadRecommendations()
    }
}

public struct AIRecommendation: Identifiable {
    public let id = UUID()
    public let title: String
    public let description: String
    public let category: RecommendationCategory
    public let priority: RecommendationPriority
    public let action: String
}

public enum RecommendationCategory: String {
    case savings = "Savings"
    case investment = "Investment"
    case debt = "Debt"
    case income = "Income"
    case expenses = "Expenses"
}

public enum RecommendationPriority: String {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
} 