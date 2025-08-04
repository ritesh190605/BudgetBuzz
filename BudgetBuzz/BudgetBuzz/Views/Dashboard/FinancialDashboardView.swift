import SwiftUI

struct FinancialDashboardView: View {
    @StateObject private var viewModel = FinancialDashboardViewModel()
    @StateObject private var themeManager = ThemeManager.shared
    @State private var selectedTimeframe: Timeframe = .year
    @State private var showingScenarioBuilder = false
    
    enum Timeframe: String, CaseIterable {
        case month = "1M"
        case quarter = "3M"
        case year = "1Y"
        case fiveYears = "5Y"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ThemeManager.ThemeColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with User Info
                        UserHeaderView(viewModel: viewModel)
                        
                        // Net Worth Card
                        NetWorthCard(viewModel: viewModel)
                        
                        // Quick Actions
                        QuickActionsView()
                        
                        // Financial Overview
                        FinancialOverviewView(viewModel: viewModel)
                        
                        // AI Recommendations
                        AIRecommendationsView(financialViewModel: viewModel)
                            .environmentObject(themeManager)
                    }
                    .padding()
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingScenarioBuilder = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(ThemeManager.ThemeColors.primary)
                    }
                }
            }
            
            if showingScenarioBuilder {
                ScenarioBuilderView()
                    .environmentObject(themeManager)
            }
        }
    }
}

struct UserHeaderView: View {
    @ObservedObject var viewModel: FinancialDashboardViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome back,")
                    .font(ThemeManager.ThemeTypography.caption)
                    .foregroundColor(ThemeManager.ThemeColors.secondaryText)
                
                Text(viewModel.userName)
                    .font(ThemeManager.ThemeTypography.title)
                    .foregroundColor(ThemeManager.ThemeColors.text)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "bell.fill")
                    .foregroundColor(ThemeManager.ThemeColors.primary)
                    .frame(width: 44, height: 44)
                    .background(ThemeManager.ThemeColors.cardBackground)
                    .clipShape(Circle())
            }
        }
    }
}

struct NetWorthCard: View {
    @ObservedObject var viewModel: FinancialDashboardViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Net Worth")
                    .font(ThemeManager.ThemeTypography.subtitle)
                    .foregroundColor(ThemeManager.ThemeColors.secondaryText)
                
                Spacer()
                
                Text("View Details")
                    .font(ThemeManager.ThemeTypography.caption)
                    .foregroundColor(ThemeManager.ThemeColors.primary)
            }
            
            Text("$\(viewModel.currentNetWorth, specifier: "%.2f")")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(ThemeManager.ThemeColors.text)
            
            HStack {
                Image(systemName: "arrow.up.right")
                    .foregroundColor(ThemeManager.ThemeColors.success)
                
                Text("+12.5% from last month")
                    .font(ThemeManager.ThemeTypography.caption)
                    .foregroundColor(ThemeManager.ThemeColors.success)
            }
        }
        .padding()
        .background(ThemeManager.ThemeColors.cardBackground)
        .cornerRadius(16)
    }
}

struct QuickActionsView: View {
    var body: some View {
        HStack(spacing: 16) {
            QuickActionButton(
                title: "Add Money",
                icon: "plus.circle.fill",
                gradient: ThemeManager.ThemeGradients.primary
            )
            
            QuickActionButton(
                title: "Invest",
                icon: "chart.line.uptrend.xyaxis",
                gradient: ThemeManager.ThemeGradients.secondary
            )
            
            QuickActionButton(
                title: "Pay",
                icon: "creditcard.fill",
                gradient: ThemeManager.ThemeGradients.primary
            )
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let gradient: LinearGradient
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
            
            Text(title)
                .font(ThemeManager.ThemeTypography.caption)
                .foregroundColor(ThemeManager.ThemeColors.text)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(gradient)
        .cornerRadius(12)
    }
}

struct FinancialOverviewView: View {
    @ObservedObject var viewModel: FinancialDashboardViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Financial Overview")
                .font(ThemeManager.ThemeTypography.subtitle)
                .foregroundColor(ThemeManager.ThemeColors.text)
            
            HStack(spacing: 16) {
                FinancialMetricCard(
                    title: "Income",
                    value: viewModel.monthlyIncome,
                    change: "+5.2%",
                    isPositive: true
                )
                
                FinancialMetricCard(
                    title: "Expenses",
                    value: viewModel.monthlyExpenses,
                    change: "-2.1%",
                    isPositive: true
                )
            }
        }
    }
}

struct FinancialMetricCard: View {
    let title: String
    let value: Double
    let change: String
    let isPositive: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(ThemeManager.ThemeTypography.caption)
                .foregroundColor(ThemeManager.ThemeColors.secondaryText)
            
            Text("$\(value, specifier: "%.2f")")
                .font(ThemeManager.ThemeTypography.subtitle)
                .foregroundColor(ThemeManager.ThemeColors.text)
            
            HStack {
                Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                    .foregroundColor(isPositive ? ThemeManager.ThemeColors.success : ThemeManager.ThemeColors.error)
                
                Text(change)
                    .font(ThemeManager.ThemeTypography.caption)
                    .foregroundColor(isPositive ? ThemeManager.ThemeColors.success : ThemeManager.ThemeColors.error)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(ThemeManager.ThemeColors.cardBackground)
        .cornerRadius(12)
    }
} 