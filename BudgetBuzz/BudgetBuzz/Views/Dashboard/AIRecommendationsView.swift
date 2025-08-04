import SwiftUI

struct AIRecommendationsView: View {
    @StateObject private var viewModel: AIRecommendationsViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    init(financialViewModel: FinancialDashboardViewModel) {
        _viewModel = StateObject(wrappedValue: AIRecommendationsViewModel(financialViewModel: financialViewModel))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("AI Recommendations")
                    .font(ThemeManager.ThemeTypography.subtitle)
                    .foregroundColor(ThemeManager.ThemeColors.text)
                
                Spacer()
                
                Button(action: {
                    viewModel.refreshRecommendations()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(ThemeManager.ThemeColors.primary)
                }
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else if let error = viewModel.error {
                Text("Error loading recommendations: \(error.localizedDescription)")
                    .font(ThemeManager.ThemeTypography.caption)
                    .foregroundColor(ThemeManager.ThemeColors.error)
            } else {
                ForEach(viewModel.recommendations) { recommendation in
                    RecommendationCard(recommendation: recommendation)
                }
            }
        }
    }
}

struct RecommendationCard: View {
    let recommendation: AIRecommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(recommendation.title)
                    .font(ThemeManager.ThemeTypography.subtitle)
                    .foregroundColor(ThemeManager.ThemeColors.text)
                
                Spacer()
                
                Text(recommendation.priority.rawValue)
                    .font(ThemeManager.ThemeTypography.caption)
                    .foregroundColor(recommendation.priority == .high ? ThemeManager.ThemeColors.error : ThemeManager.ThemeColors.success)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(recommendation.priority == .high ? ThemeManager.ThemeColors.error.opacity(0.1) : ThemeManager.ThemeColors.success.opacity(0.1))
                    .cornerRadius(8)
            }
            
            Text(recommendation.description)
                .font(ThemeManager.ThemeTypography.body)
                .foregroundColor(ThemeManager.ThemeColors.secondaryText)
            
            Button(action: {}) {
                Text(recommendation.action)
                    .font(ThemeManager.ThemeTypography.caption)
                    .foregroundColor(ThemeManager.ThemeColors.primary)
            }
        }
        .padding()
        .background(ThemeManager.ThemeColors.cardBackground)
        .cornerRadius(12)
    }
} 