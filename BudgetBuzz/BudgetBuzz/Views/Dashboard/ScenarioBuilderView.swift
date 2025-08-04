import SwiftUI

struct FinancialChange: Identifiable {
    let id = UUID()
    var type: String
    var amount: Double
    var description: String
}

struct ScenarioBuilderView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var financialChanges: [FinancialChange] = []
    @State private var timeHorizon: Int = 12 // months
    @State private var riskLevel: Int = 2 // 1-5
    @State private var showingAddChange = false
    
    // Form states
    @State private var changeType = "Income"
    @State private var changeAmount = ""
    @State private var changeDescription = ""
    
    private let changeTypes = ["Income", "Expense", "Investment", "Savings"]
    
    var body: some View {
        NavigationView {
            ZStack {
                ThemeManager.ThemeColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Time Horizon Selector
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Time Horizon (months)")
                                .font(ThemeManager.ThemeTypography.subtitle)
                                .foregroundColor(ThemeManager.ThemeColors.text)
                            
                            Slider(value: .init(
                                get: { Double(timeHorizon) },
                                set: { timeHorizon = Int($0) }
                            ), in: 1...60, step: 1)
                            .tint(ThemeManager.ThemeColors.primary)
                            
                            Text("\(timeHorizon) months")
                                .font(ThemeManager.ThemeTypography.caption)
                                .foregroundColor(ThemeManager.ThemeColors.secondaryText)
                        }
                        .padding()
                        .background(ThemeManager.ThemeColors.cardBackground)
                        .cornerRadius(12)
                        
                        // Risk Level Selector
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Risk Level")
                                .font(ThemeManager.ThemeTypography.subtitle)
                                .foregroundColor(ThemeManager.ThemeColors.text)
                            
                            Slider(value: .init(
                                get: { Double(riskLevel) },
                                set: { riskLevel = Int($0) }
                            ), in: 1...5, step: 1)
                            .tint(ThemeManager.ThemeColors.primary)
                            
                            Text("Level \(riskLevel)")
                                .font(ThemeManager.ThemeTypography.caption)
                                .foregroundColor(ThemeManager.ThemeColors.secondaryText)
                        }
                        .padding()
                        .background(ThemeManager.ThemeColors.cardBackground)
                        .cornerRadius(12)
                        
                        // Financial Changes List
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Financial Changes")
                                    .font(ThemeManager.ThemeTypography.subtitle)
                                    .foregroundColor(ThemeManager.ThemeColors.text)
                                
                                Spacer()
                                
                                Button(action: { showingAddChange = true }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(ThemeManager.ThemeColors.primary)
                                }
                            }
                            
                            if financialChanges.isEmpty {
                                Text("No changes added yet")
                                    .font(ThemeManager.ThemeTypography.body)
                                    .foregroundColor(ThemeManager.ThemeColors.secondaryText)
                            } else {
                                ForEach(financialChanges) { change in
                                    ChangeCard(change: change)
                                }
                            }
                        }
                        .padding()
                        .background(ThemeManager.ThemeColors.cardBackground)
                        .cornerRadius(12)
                    }
                    .padding()
                }
            }
            .navigationTitle("Scenario Builder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ThemeManager.ThemeColors.primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Save scenario logic here
                        dismiss()
                    }
                    .foregroundColor(ThemeManager.ThemeColors.primary)
                }
            }
            .sheet(isPresented: $showingAddChange) {
                AddChangeSheet(
                    changeTypes: changeTypes,
                    selectedType: $changeType,
                    amount: $changeAmount,
                    description: $changeDescription,
                    financialChanges: $financialChanges,
                    isPresented: $showingAddChange
                )
                .environmentObject(themeManager)
            }
        }
    }
}

struct ChangeCard: View {
    let change: FinancialChange
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(change.type)
                    .font(ThemeManager.ThemeTypography.subtitle)
                    .foregroundColor(ThemeManager.ThemeColors.text)
                
                Text(change.description)
                    .font(ThemeManager.ThemeTypography.caption)
                    .foregroundColor(ThemeManager.ThemeColors.secondaryText)
            }
            
            Spacer()
            
            Text(String(format: "$%.2f", change.amount))
                .font(ThemeManager.ThemeTypography.body)
                .foregroundColor(change.type == "Expense" ? ThemeManager.ThemeColors.error : ThemeManager.ThemeColors.success)
        }
        .padding()
        .background(ThemeManager.ThemeColors.cardBackground)
        .cornerRadius(8)
    }
}

struct AddChangeSheet: View {
    let changeTypes: [String]
    @Binding var selectedType: String
    @Binding var amount: String
    @Binding var description: String
    @Binding var financialChanges: [FinancialChange]
    @Binding var isPresented: Bool
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Type", selection: $selectedType) {
                    ForEach(changeTypes, id: \.self) { type in
                        Text(type).tag(type)
                    }
                }
                
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                
                TextField("Description", text: $description)
            }
            .navigationTitle("Add Change")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        if let amountDouble = Double(amount), !description.isEmpty {
                            financialChanges.append(
                                FinancialChange(
                                    type: selectedType,
                                    amount: amountDouble,
                                    description: description
                                )
                            )
                            isPresented = false
                        }
                    }
                }
            }
        }
    }
} 